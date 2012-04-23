# encoding: utf-8

#
# This class holds an LDAP object. Attributes are fetched lazily.
#
module RubyLdapom
  class LdapNode
    attr_reader :dn
    attr_reader :clean

    def initialize(connection, dn, new = false)
      @attributes = RubyLdapom::LdapAttributes.new
      @conn = connection
      @dn = dn
      @clean = true
      @attributes_loaded = false
    end

    # Public: Loads the node's attributes.
    #
    # Returns whether the node existed (i.e. the attributes could be loaded).
    def load_attributes
      result = @conn.search(:base => @conn.base_dn,
                            :filter => Net::LDAP::Filter.eq("dn", @dn),
                            :scope => Net::LDAP::SearchScope_BaseObject,
                            :size => 1).first

      attributes = Hash.new
      result.each do |name, value|
        attributes[name]= value
      end

      @attributes = RubyLdapom::LdapAttributes.new(attributes)
      @attributes_loaded = true

      return true
    end

    # Public: Saves the changes to the node or adds a new node if needed.
    #
    # Returns an LdapNode object of the saved node or nil if the operation failed.
    def save
      result = nil

      unless @new
        unless @attributes.changes.empty? || @clean
          @conn.modify :dn => @dn, :operations => @attributes.changes
          @attributes.discard_changes
        end
        result = self
      else
        result = @conn.add(@dn, @attributes.to_hash)
      end

      return result
    end

    # Public: Getter for the attributes of the node. Loads the attributes if needed.
    #
    # Returns an LdapAttribute object.
    def attributes
      unless @attributes_loaded
        load_attributes
      end
      @attributes
    end

    # Public: Setter for the attributes of the node. Loads the attributes first if needed.
    #
    # Returns the changed LdapAttribute object.
    def attributes=(value)
      unless @attributes_loaded
        load_attributes
      end
      if @attributes != value
        @clean = false
      end

      @attributes = value
    end

    # Public: Deletes the node.
    #
    # Returns the deleted node if it existed or nil otherwise.
    def delete
      unless @new
        return self if @conn.delete :dn => @dn
      end

      return false
    end
  end
end
