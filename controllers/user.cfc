<cfcomponent displayname="User" output="false">

	<cfset variables.fw = "">

<!--- init --->
	<cffunction name="init" hint="requires fw"
		access="public" output="false" returntype="any">
		<cfargument name="fw">

		<cfset variables.fw = arguments.fw>

		<cfreturn this>
	</cffunction>

<!--- get/setUserService --->
	<cffunction name="setUserService" access="public" output="false" returntype="void">
		<cfargument name="userService" type="any" required="true" />
		<cfset variables.userService = arguments.userService />
	</cffunction>
	<cffunction name="getUserService" hint=""
		access="public" output="false" returntype="any">
		<cfreturn variables.userService />
	</cffunction>

<!--- before --->
	<cffunction name="before" hint="(runs before each item-method call);used to do something b4 i removed dept and roll"
		access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
	</cffunction>

<!--- form --->
	<cffunction name="form" hint="if no user in rc, set one using getUserService(); get lists of depts? and rols?"
		access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">

		<!--- if the user object does not exist, grab it --->
		<cfif not structkeyexists(rc,'user')>
			<cfset rc.user = getUserService().get(argumentCollection=rc)>
		</cfif>

	</cffunction>

<!--- startSave --->
	<cffunction name="startSave" hint="validate the user: the user stored in rc? if invalid--> new user; populate rc.user; redirect to user.form prn errors; rc.user store dept info; if new pword-->hash, salt, store"
		access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">

		<cfset var userService = getUserService() />

		<!--- validate the user --->
		<cfset rc.user = userService.get(argumentCollection=rc) />
		<cfset rc.message = userService.validate(argumentCollection=rc) />

		<!--- if there were validation errors, grab a blank user to populate and send back to the form --->
		<cfif not arrayIsEmpty(rc.message)>
			<cfset rc.user = userService.new() />
		</cfif>

		<!--- update the user object with the data entered --->
		<cfset variables.fw.populate( cfc = rc.user, trim = true )>

		<!--- if there were error, redirect the user to the form --->
		<cfif not arrayIsEmpty(rc.message)>
			<cfset variables.fw.redirect('user.form','user,message') />
		</cfif>

	</cffunction>

<!--- endSave --->
	<cffunction name="endSave" hint="user has been saved at this point; redirect to user.list page"
		access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">

		<!--- user saved so by default lets go back to the users list page --->
		<cfset variables.fw.redirect("user.list")>
	</cffunction>

<!--- endDelete --->
	<cffunction name="endDelete" hint="user has been deleted at this point; redirect to user.list page"
		access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">

		<!--- user deleted so by default lets go back to the users list page --->
		<cfset variables.fw.redirect("user.list")>
	</cffunction>

</cfcomponent>