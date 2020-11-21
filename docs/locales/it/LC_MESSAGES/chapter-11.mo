��    E      D              l  �   m  �   	  u   �  =   6     t     �  !   �     �  ,   �  �   �  L   �  8  �  8   	  �   F	     �	  �   �	  �   �
      �     �       f    V  �     �  p   �  J   b  �   �  =   E  ;   �  y   �  7   9  �  q  V     Z   _  3   �  �   �  �   �  1   x  [   �  F     
   M  h   X  �   �  �   Y    �  &   �  $        7     V  &   q  .   �  R   �          '  
   -  	   8     B  �   K  +   6     b  *   k  -   �     �  )   �  *     "   9  0   \  (   �  +   �  x  �  �   [   �   �   u   �!  =   $"     b"     o"  !   w"     �"  ,   �"  �   �"  L   u#  8  �#  8   �$  �   4%     �%  �   �%  �   �&      �'     �'     (  f  (  V  s)     �+  p   �+  J   P,  �   �,  =   3-  ;   q-  y   �-  7   '.  �  _.  V   �/  Z   M0  3   �0  �   �0  �   }1  1   f2  [   �2  F   �2  
   ;3  h   F3  �   �3  �   G4    �4  &   �6  $    7     %7     D7  &   _7  .   �7  R   �7     8     8  
   8  	   &8     08  �   98  +   $9     P9  *   Y9  -   �9     �9  )   �9  *   �9  "   ':  0   J:  (   {:  +   �:   **At this time we cannot guarantee that the following plugins work well. They have been ported from web2py where they do work but testing is still needed** **Important:** ``Tags`` are automatically hierarchical. For example, if a user has a group tag ‘teacher/high-school/physics’, then all the following seaches will return the user: **Warning: the API described in this chapter is new and subject to changes. Make sure you keep your code up to date** And you can check for a user permission via an explicit join: Auth Plugins Auth UI Authentication and Access control Configuring PAM is the easiest: For example you could create a table groups: Here ``@action.uses(auth.user)`` tells py4web that this action requires a logged in user and should redirect to login if no user is logged in. Here the developer queries the db for all records having the desired tag(s): Here the use case is group based access control where the developer first checks if a user is a member of the ``'manager'`` group, if the user is not a manager (or no one is logged in) py4web redirects to the ``'not authorized url'``. If the user is in the correct group then py4web displays ‘hello manager’: If the ``auth_user`` table does not exist it is created. If you need to change the style of the component you can edit “components/auth.html” to suit your needs. It is mostly HTML with some special Vue ``v-*`` tags. LDAP Notice here ``permissions.find(permission)`` generates a query for all groups with the permission and we further filter those groups for those the current user is member of. We count them and if we find any, then the user has the permission. Notice that one table can have multiple associated ``Tags`` objects. The name groups here is completely arbitary but has a specific semantic meaning. Different ``Tags`` objects are orthogonal to each other. The limit to their use is your creativity. OAuth2 with Facebook (tested OK) OAuth2 with Google (tested OK) PAM Plugins are defined in “py4web/utils/auth_plugins” and they have a hierachical structure. Some are exclusive and some are not. For example, default, LDAP, PAM, and SAML are exclusive (the developer has to pick one). Default, Google, Facebook, and Twitter OAuth are not exclusive (the developer can pick them all and the user gets to choose using the UI). Py4web does not have the concept of groups as web2py does. Experience showed that while that mechanism is powerful it suffers from two problems: it is overkill for most apps, and it is not flexible enough for very complex apps. Py4web provides a general purpose tagging mechanism that allows the developer to tag any record of any table, check for the existence of tags, as well as checking for records containing a tag. Group membership can be thought of a type of tag that we apply to users. Permissions can also be tags. Developer are free to create their own logic on top of the tagging system. Tags and Permissions The ``<auth/>`` components will automatically adapt to display login forms as required by the installed plugins. The ``auth.enable()`` step creates and exposes the following RESTful APIs: The ``auth.register_plugin(...)`` **must** come before the ``auth.enable()`` since it makes no sense to expose APIs before desired plugins are mounted. The client id and client secret must be provided by Facebook. The client id and client secret must be provided by Google. The component files (js/html) define a Vue component ``<auth/>`` which is used in the template file auth.html as follows: The configuration step is optional and discussed later. The import step is obvious. The second step does not perform any operation other than telling the Auth object which session object to use and which database to use. Auth data is stored in ``session['user']`` and, if a user is logged in, the user id is stored in session[‘user’][‘id’]. The db object is used to store persistent info about the user in a table ``auth_user`` with the following fields: Then create a zapper group, give it a permission, and make a user member of the group: Then you can add one or more tags to records of the table as well as remove existing tags: There two ways to use the Auth object in an action: This means that slashes have a special meaning for tags. Slahes at the beginning or the end of a tag are optional. All other chars are allowed on equal footing. This one like all plugins must be imported and registered. Once registered the UI (components/auth) and the RESTful APIs know how to handle it. The constructor of this plugins does not require any arguments (where other plugins do). Those marked with a (+) require a logged in user. To use it, first of all you need to import it, instantiate it, configure it, and enable it. To use the tagging system you need to create an object to tag a table: Using Auth We leave it to you as an exercise to create a fixture ``has_membership`` to enable the following syntax: With ``@action.uses(auth)`` we tell py4web that this action needs to have information about the user, then try to parse the session for a user session. You can create your own web UI to login users using the above APIs but py4web provides one as an example, implemented in the following files: You can pretty much use this file un-modified. It extends the current layout and embeds the ``<auth/>`` component into the page. It then uses ``utils.app().start();`` (py4web magic) to render the content of ``<div id="vue">...</div>`` using Vue.js. ``components/auth.js`` also automatically loads ``components/auth.html`` into the component placeholder (more py4web magic). The component is responsible for rendering the login/register/etc forms using reactive html and GETing/POSTing data to the Auth service APIs. \_scaffold/static/components/auth.html \_scaffold/static/components/auth.js \_scaffold/templates/auth.html ``groups.find('teacher')`` ``groups.find('teacher/high-school')`` ``groups.find('teacher/high-school/physics')`` action_token (used to verify email, block users, and other tasks, also see later). and to Tags: email first_name last_name password py4web comes with a an object Auth and a system of plugins for user authentication and access control. It has the same name as the corresponding web2py one and serves the same purpose but the API and internal design is very different. sso_id (used for single sign on, see later) username {appname}/auth/api/change_email (POST) (+) {appname}/auth/api/change_password (POST) (+) {appname}/auth/api/login (POST) {appname}/auth/api/logout (GET, POST) (+) {appname}/auth/api/profile (GET, POST) (+) {appname}/auth/api/register (POST) {appname}/auth/api/request_reset_password (POST) {appname}/auth/api/reset_password (POST) {appname}/auth/api/verify_email (GET, POST) Project-Id-Version: py4web 
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2020-11-02 22:29+0100
PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE
Last-Translator: FULL NAME <EMAIL@ADDRESS>
Language: pt
Language-Team: pt <LL@li.org>
Plural-Forms: nplurals=2; plural=(n != 1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Generated-By: Babel 2.6.0
 **At this time we cannot guarantee that the following plugins work well. They have been ported from web2py where they do work but testing is still needed** **Important:** ``Tags`` are automatically hierarchical. For example, if a user has a group tag ‘teacher/high-school/physics’, then all the following seaches will return the user: **Warning: the API described in this chapter is new and subject to changes. Make sure you keep your code up to date** And you can check for a user permission via an explicit join: Auth Plugins Auth UI Authentication and Access control Configuring PAM is the easiest: For example you could create a table groups: Here ``@action.uses(auth.user)`` tells py4web that this action requires a logged in user and should redirect to login if no user is logged in. Here the developer queries the db for all records having the desired tag(s): Here the use case is group based access control where the developer first checks if a user is a member of the ``'manager'`` group, if the user is not a manager (or no one is logged in) py4web redirects to the ``'not authorized url'``. If the user is in the correct group then py4web displays ‘hello manager’: If the ``auth_user`` table does not exist it is created. If you need to change the style of the component you can edit “components/auth.html” to suit your needs. It is mostly HTML with some special Vue ``v-*`` tags. LDAP Notice here ``permissions.find(permission)`` generates a query for all groups with the permission and we further filter those groups for those the current user is member of. We count them and if we find any, then the user has the permission. Notice that one table can have multiple associated ``Tags`` objects. The name groups here is completely arbitary but has a specific semantic meaning. Different ``Tags`` objects are orthogonal to each other. The limit to their use is your creativity. OAuth2 with Facebook (tested OK) OAuth2 with Google (tested OK) PAM Plugins are defined in “py4web/utils/auth_plugins” and they have a hierachical structure. Some are exclusive and some are not. For example, default, LDAP, PAM, and SAML are exclusive (the developer has to pick one). Default, Google, Facebook, and Twitter OAuth are not exclusive (the developer can pick them all and the user gets to choose using the UI). Py4web does not have the concept of groups as web2py does. Experience showed that while that mechanism is powerful it suffers from two problems: it is overkill for most apps, and it is not flexible enough for very complex apps. Py4web provides a general purpose tagging mechanism that allows the developer to tag any record of any table, check for the existence of tags, as well as checking for records containing a tag. Group membership can be thought of a type of tag that we apply to users. Permissions can also be tags. Developer are free to create their own logic on top of the tagging system. Tags and Permissions The ``<auth/>`` components will automatically adapt to display login forms as required by the installed plugins. The ``auth.enable()`` step creates and exposes the following RESTful APIs: The ``auth.register_plugin(...)`` **must** come before the ``auth.enable()`` since it makes no sense to expose APIs before desired plugins are mounted. The client id and client secret must be provided by Facebook. The client id and client secret must be provided by Google. The component files (js/html) define a Vue component ``<auth/>`` which is used in the template file auth.html as follows: The configuration step is optional and discussed later. The import step is obvious. The second step does not perform any operation other than telling the Auth object which session object to use and which database to use. Auth data is stored in ``session['user']`` and, if a user is logged in, the user id is stored in session[‘user’][‘id’]. The db object is used to store persistent info about the user in a table ``auth_user`` with the following fields: Then create a zapper group, give it a permission, and make a user member of the group: Then you can add one or more tags to records of the table as well as remove existing tags: There two ways to use the Auth object in an action: This means that slashes have a special meaning for tags. Slahes at the beginning or the end of a tag are optional. All other chars are allowed on equal footing. This one like all plugins must be imported and registered. Once registered the UI (components/auth) and the RESTful APIs know how to handle it. The constructor of this plugins does not require any arguments (where other plugins do). Those marked with a (+) require a logged in user. To use it, first of all you need to import it, instantiate it, configure it, and enable it. To use the tagging system you need to create an object to tag a table: Using Auth We leave it to you as an exercise to create a fixture ``has_membership`` to enable the following syntax: With ``@action.uses(auth)`` we tell py4web that this action needs to have information about the user, then try to parse the session for a user session. You can create your own web UI to login users using the above APIs but py4web provides one as an example, implemented in the following files: You can pretty much use this file un-modified. It extends the current layout and embeds the ``<auth/>`` component into the page. It then uses ``utils.app().start();`` (py4web magic) to render the content of ``<div id="vue">...</div>`` using Vue.js. ``components/auth.js`` also automatically loads ``components/auth.html`` into the component placeholder (more py4web magic). The component is responsible for rendering the login/register/etc forms using reactive html and GETing/POSTing data to the Auth service APIs. \_scaffold/static/components/auth.html \_scaffold/static/components/auth.js \_scaffold/templates/auth.html ``groups.find('teacher')`` ``groups.find('teacher/high-school')`` ``groups.find('teacher/high-school/physics')`` action_token (used to verify email, block users, and other tasks, also see later). and to Tags: email first_name last_name password py4web comes with a an object Auth and a system of plugins for user authentication and access control. It has the same name as the corresponding web2py one and serves the same purpose but the API and internal design is very different. sso_id (used for single sign on, see later) username {appname}/auth/api/change_email (POST) (+) {appname}/auth/api/change_password (POST) (+) {appname}/auth/api/login (POST) {appname}/auth/api/logout (GET, POST) (+) {appname}/auth/api/profile (GET, POST) (+) {appname}/auth/api/register (POST) {appname}/auth/api/request_reset_password (POST) {appname}/auth/api/reset_password (POST) {appname}/auth/api/verify_email (GET, POST) 