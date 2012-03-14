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
    end

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
    end

    def save
      unless @new
        unless @attributes.changes.empty? || @clean
          @conn.modify :dn => @dn, :operations => @attributes.changes
          @attributes.discard_changes
        end
      else

      end

      return true
    end

    def attributes
      @attributes
    end

    def attributes=(value)
      if @attributes != value
        @clean = false
      end

      @attributes = value
    end

    def delete
    end

    def set_password(password)
    end
  end
end
