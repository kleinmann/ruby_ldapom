# encoding: utf-8

#
# This class holds all parameters to connect to an LDAP server.
#
module RubyLdapom
  class LdapConnection
    attr_reader :base_dn

    # Public: Initializes an LDAP connection and connects.
    # 
    # host - The String host to connect to.
    # port - The String port to connect to (default: 389).
    # login_dn - The String login DN to bind to.
    # base_dn - The tree base DN.
    # password - The String password for the login DN.
    #
    # Returns whether we are successfully connected.
    def initialize(host, port = 389, login_dn, base_dn, password)
      @host = host
      @port = port
      @login_dn = login_dn
      @base_dn = base_dn
      @password = password

      return connect
    end

    # Public: Connects to an LDAP server and binds to it.
    #
    # Returns whether the binding was successful.
    def connect
      @conn ||= Net::LDAP.new
      @conn.host = @host
      @conn.port = @port
      @conn.auth "#{@login_dn},#{@base_dn}", @password

      if @conn.bind
        return true
      else
        return false
      end
    end

    # Public: Tries to authenticate with a separate bind to check the combination for validity.
    #
    # dn - The String DN to bind to. base_dn will be appended.
    # password - The String password to use.
    #
    # Returns whether the authentication was successful.
    def authenticate(dn, password)
      if @conn.bind(:username => "#{dn},#{@base_dn}", :password => password)
        @conn.bind "#{@login_dn},#{@base_dn}", @password
        return true
      else
        return false
      end
    end

    def add(dn, attributes)
    end

    def rename(dn, newrdn)
    end

    def delete(dn)
    end

    def delete_r(dn)
    end

    def set_password(dn, password)
    end

    # Public: Conveniently wraps Net::LDAP.search with sensible defaults.
    #
    # args - A Hash of arguments for search (default: { :base => @base_dn,
    #   :filter => Net::LDAP::Filter.eq("objectclass", "*"),
    #   :scope => Net::LDAP::SearchScope_WholeSubtree }):
    #         :base - The tree-base to search from.
    #         :filter - An instance of Net::LDAP::Filter (optional).
    #         :scope - One of: Net::LDAP::SearchScope_BaseObject, Net::LDAP::SearchScope_SingleLevel,
    #                   Net::LDAP::SearchScope_WholeSubtree. Default is WholeSubtree (optional).
    #         :size - The maximum Integer number of results to return. 0 is no limit and default (optional).
    #         :attributes - A String or Array of Strings specifying which attributes to return (optional).
    #
    # Returns an LdapNode or an Array of LdapNodes of the result set.
    def search(args = {
      :base => @base_dn,
      :filter => Net::LDAP::Filter.eq("objectclass", "*"),
      :scope => Net::LDAP::SearchScope_WholeSubtree
    })
    end

    def dn_exists?(dn)
    end

    def get_ldap_node(dn)
    end

    def retrieve_ldap_node(dn)
    end

    def new_ldap_node(dn)
    end
  end

end
