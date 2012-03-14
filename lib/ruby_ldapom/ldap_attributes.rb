# encoding: utf-8

#
# This class holds a set of LDAP-attributes with the same name
#
module RubyLdapom
  class LdapAttributes
    # Public: contains all changes that were made in a format that can be used
    # by net-ldap directly to update the DN.
    attr_reader :changes

    # Public: Initializes the object with empty changes.
    #
    # attributes - A Hash of preset attributes (default: {}).
    def initialize(attributes = {})
      @changes = Array.new
      @attributes = attributes
    end

    # Public: Returns all attribute names.
    #
    # Returns an Array of attribute names.
    def keys
      @attributes.keys
    end

    # Public: Returns all attribute values.
    #
    # Returns an Array of attribute values.
    def values
      @attributes.values
    end

    # Public: Returns the value of a given attribute.
    #
    # key - String name of the attribute.
    #
    # Returns a value of varying type.
    def [](key)
      @attributes[key]
    end

    # Public: Alias for #store(key, value).
    def []=(key, value)
      store(key, value)
    end

    # Public: Sets the value of a given attribute.
    #
    # key - String name of the attribute.
    # value - Value of the attribute of varying type.
    #
    # Returns the value.
    def store(key, value)
      if @attributes[key].nil?
        @attributes[key] = value
        @changes << [:add, key, value]
      else
        if value.nil?
          return delete(key)
        else
          @attributes[key] = value
          @changes << [:replace, key, value]
        end
      end

      return value
    end

    # Public: Deletes a given attribute.
    #
    # key - String name of the attribute.
    #
    # Returns the value of the deleted attribute or nil if the attribute doesn't exist.
    def delete(key)
      value = nil

      unless @attributes[key].nil?
        value = @attributes[key]

        @attributes.delete(key)
        @changes << [:delete, key, nil]

        return value
      else
        return nil
      end
    end

    # Public: Iterates over all attributes.
    # Use like any Hash iterator.
    def each
      @attributes.each do |key, value|
        yield key, value
      end
    end

    # Public: Tells if there are any attributes.
    #
    # Returns whether there are any attributes.
    def empty?
      @attributes.length == 0
    end

    # Public: Alias for #inspect.
    def to_s
      inspect
    end

    # Public: Inspects the attributes hash.
    #
    # Returns a String representation of the attributes.
    def inspect
      @attributes.inspect
    end

    # Public: Alias for #length.
    def size
      length
    end

    # Public: Tells the number of attributes.
    #
    # Returns the Integer number of attributes.
    def length
      @attributes.length
    end

    # Public: Deletes all changes. To be used after saving the corresponding LDAP node.
    def discard_changes
      @changes = Array.new
    end
  end

end
