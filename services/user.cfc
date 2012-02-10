<cfcomponent displayname="UserService" output="false">

	<cfset variables.users = structNew()>

	<cffunction name="init" hint="creates a new user with a lot of data I don't need"
		access="public" output="false" returntype="any">

		<cfscript>
		var user = "";

		// since services are cached, user data well be persisted
		// ideally, this would be saved elsewhere, e.g. database

		// FIRST
		user = new();
		user.setId("1");
		user.setFirstName("Admin");
		user.setLastName("User");
		user.setEmail("admin@mysite.com");

		variables.users[user.getId()] = user;

		// SECOND
		user = new();
		user.setId("2");
		user.setFirstName("Larry");
		user.setLastName("Stooge");
		user.setEmail("larry@stooges.com");

		variables.users[user.getId()] = user;

		// THIRD
		user = new();
		user.setId("3");
		user.setFirstName("Moe");
		user.setLastName("Stooge");
		user.setEmail("moe@stooges.com");

		variables.users[user.getId()] = user;

		// BEN
		variables.nextid = 4;
		</cfscript>

		<cfreturn this>
	</cffunction>

	<cffunction name="delete" hint="delete the struct that represents a specific user using the ID that is input"
		access="public" output="false" returntype="boolean">
		<cfargument name="id" type="string" required="true">

		<cfreturn structDelete(variables.users, arguments.id)>
	</cffunction>

	<cffunction name="get" hint="return the user with the ID that was input (or a new user if empty/non-existant ID)"
		access="public" output="false" returntype="any">
		<cfargument name="id" type="string" required="false" default="">

		<cfset var result = "">

		<cfif len(id) AND structKeyExists(variables.users, id)>
			<cfset result = variables.users[id]>
		<cfelse>
			<cfset result = new()>
		</cfif>

		<cfreturn result>
	</cffunction>

	<cffunction name="getByEmail" hint="return the user with the email that was input (or a new user if empty/non-existant email)"
		access="public" returntype="any">
		<cfargument name="email" type="string" required="false" default="">

		<cfset var result = "">
		<cfset var userid = "">
		<cfset var user = "">

		<cfif len(email)>
			<!--- loop through the users, looking for a matching email address --->
			<cfloop collection="#variables.users#" item="userid">
				<cfset user = variables.users[userid] />
				<cfif not comparenocase(arguments.email,user.getEmail())>
					<cfset result = user />
				</cfif>
			</cfloop>
		</cfif>

		<!--- if there is no user with a matching email address, return a blank user --->
		<cfif not isstruct(result)>
			<cfset result = new()>
		</cfif>

		<cfreturn result>
	</cffunction>

	<cffunction name="list" hint="return the collection of users"
		access="public" output="false" returntype="struct">
		<cfreturn variables.users>
    </cffunction>

	<cffunction name="new" hint="create an empty user; (i.e. call the user bean init)"
		access="public" output="false" returntype="any">
		<cfreturn createObject("component", "userManager.model.User").init()>
	</cffunction>

	<cffunction name="validate" hint="validates multiple characteristics of a user; returns array of errors"
		access="public" output="false" returntype="Array">
		<cfargument name="user" type="any" required="true" />
		<cfargument name="firstName" type="string" required="false" default="" />
		<cfargument name="lastName" type="string" required="false" default="" />
		<cfargument name="email" type="string" required="false" default="" />
		<cfset var aErrors = arrayNew(1) />
		<!--- check to see if a user exists with the email address --->
		<cfset var userByEmail = getByEmail(arguments.email) />

		<!--- if the user is new, make sure there is a password --->
		<cfif not arguments.user.getId() and not len(arguments.password)>
			<cfset arrayAppend(aErrors,"Please enter a password for the user") />
		<!--- make sure the password is valid --->
		<cfelseif len(arguments.password)>
			<cfset aErrors = checkPassword(user=arguments.user,
				newPassword=arguments.password,
				retypePassword=arguments.password) />
		</cfif>

		<!--- first name is required --->
		<cfif not len(arguments.user.getFirstName()) and not len(arguments.firstName)>
			<cfset arrayAppend(aErrors,"Please enter the user's first name") />
		</cfif>

		<!--- last name is required --->
		<cfif not len(arguments.user.getLastName()) and not len(arguments.lastName)>
			<cfset arrayAppend(aErrors,"Please enter the user's last name") />
		</cfif>

		<!--- email address is required --->
		<cfif not len(arguments.user.getEmail()) and not len(arguments.email)>
			<cfset arrayAppend(aErrors,"Please enter the user's email address") />
		<!--- verify the email is a valid format --->
		<cfelseif len(arguments.email) and not isEmail(arguments.email)>
			<cfset arrayAppend(aErrors,"Please enter a valid email address") />
		<!--- verify the email address is unique for this user --->
		<cfelseif len(arguments.email) and compare(arguments.email,arguments.user.getEmail()) and userByEmail.getId()>
			<cfset arrayAppend(aErrors,"A user already exists with this email address, please enter a new address.") />
		</cfif>

		<cfreturn aErrors />
	</cffunction>

	<cffunction name="save" hint="saves the user; looks like a stub"
		access="public" output="false" returntype="void">
		<cfargument name="user" type="any" required="true">

		<cfset var newId = 0>

		<!--- since we have an id we are updating a user --->
		<cfif arguments.user.getId()>
			<cfset variables.users[arguments.user.getId()] = arguments.user>
		<cfelse>
			<!--- otherwise a new user is being saved --->
			<!--- BEN --->
			<cflock type="exclusive" name="setNextID" timeout="10" throwontimeout="false">
				<cfset newId = variables.nextid>
				<cfset variables.nextid = variables.nextid + 1>
			</cflock>
			<!--- END BEN --->

			<cfset arguments.user.setId(newId)>

			<cfset variables.users[newId] = arguments.user>
		</cfif>
	</cffunction>

</cfcomponent>