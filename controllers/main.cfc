<cfcomponent>
	<cfset variables.fw = '' />
	
	<cffunction name="init" access="public" returntype="void">
		<cfargument name="fw" type="any" required="yes" />
		
		<cfset variables.fw = arguments.fw />
	</cffunction>

	<cffunction name="setUserService" access="public" output="false" returntype="void">
		<cfargument name="userService" type="any" required="true" />
		<cfset variables.userService = arguments.userService />
	</cffunction>
	<cffunction name="getUserService" access="public" output="false" returntype="any">
		<cfreturn variables.userService />
	</cffunction>

	<cffunction name="password" hint="looks like it's checking auth (R or N?)"
		access="public" returntype="void">
		<cfargument name="rc" type="struct" required="yes" />
		
		<cfset rc.id = session.auth.user.getId() />
		<cfset rc.user = getUserService().get(rc.id) />
	</cffunction>


</cfcomponent>