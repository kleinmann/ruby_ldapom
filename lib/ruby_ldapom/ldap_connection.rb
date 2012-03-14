# encoding: utf-8

#
# This class holds all parameters to connect to an LDAP server.
#
module RubyLdapom
  class LdapConnection
    # Public: Initializes an LDAP connection.
    # 
    # host - The String host to connect to.
    # port - The String port to connect to (default: 389).
    # login_dn - The String login DN to bind to.
    # password - The String password for the login DN.
    #
    # Returns nothing.
    def initialize(host, port = 389, login_dn, password)
      @host = host
      @port = port
      @login_dn = login_dn
      @password = password
    end

    # Public: Connects to an LDAP server and binds to it.
    #
    # Returns whether the binding was successful.
    def connect
      @conn ||= Net::LDAP.new
      @conn.host = @host
      @conn.port = @port
      @conn.auth @login_dn, @password

      if @conn.bind
        return true
      else
        return false
      end
    end

    # Public: Tries to authenticate with a separate bind to check the combination for validity.
    #
    # dn - The String DN to bind to.
    # password - The String password to use.
    #
    # Returns whether the authentication was successful.
    def authenticate(dn, password)
      if @conn.bind(:username => dn, :password => password)
        @conn.bind @dn, @password
        return true
      else
        return false
      end
    end
  end

end
