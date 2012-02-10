<cfcomponent displayname="User" output="false">

	<cfset variables.id = 0 />
	<cfset variables.firstName = "" />
	<cfset variables.lastName = "" />
	<cfset variables.email = "" />

	<cffunction name="init" access="public" output="false" returntype="User">
		<cfreturn this />
	</cffunction>

	<cffunction name="setId" access="public" output="false">
		<cfargument name="id" type="string" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>
	<cffunction name="getId" access="public" returntype="string" output="false">
		<cfreturn variables.id />
	</cffunction>

	<cffunction name="setFirstName" access="public" output="false">
		<cfargument name="firstName" type="string" required="true" />
		<cfset variables.firstName = arguments.firstName />
	</cffunction>
	<cffunction name="getFirstName" access="public" returntype="string" output="false">
		<cfreturn variables.firstName />
	</cffunction>

	<cffunction name="setLastName" access="public" output="false">
		<cfargument name="lastName" type="string" required="true" />
		<cfset variables.lastName = arguments.lastName />
	</cffunction>
	<cffunction name="getLastName" access="public" returntype="string" output="false">
		<cfreturn variables.lastName />
	</cffunction>

	<cffunction name="setEmail" access="public" output="false">
		<cfargument name="email" type="string" required="true" />
		<cfset variables.email = arguments.email />
	</cffunction>
	<cffunction name="getEmail" access="public" returntype="string" output="false">
		<cfreturn variables.email />
	</cffunction>

</cfcomponent>