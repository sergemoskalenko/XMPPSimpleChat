# XMPPSimpleChat
XMPPSimpleChat - This tiny project is written very quickly as the test task.  https://ua.linkedin.com/in/sergemoskalenko


1) Login view
	- Login/pass input fields
	- Login button
	- Redirect to next screen after successful authorisation on XMPP Server
	- Progress bar during login/Alert in case of wrong username/pass or connection error
	- Save user data to user defaults in case of successful authorisation

2) Chat view
	- Connection status label (displays status of current connection: Connecting, Connected, Disconnected)
	- username textfield full JID: to whom to send message when Send button pressed
	- TableView to show incoming/outgoing messages (from cache, no need to store in DB). Show username (From) and body of message
	- TextView to enter text message (multiline, max 3 lines)
	- Send button
	- Logout button
3) XMPP
	- connect/handle messages (receive, send) in parallel thread
	- connectivity handler (handle change from WiFi to cellular, no internet)
	- resend cached messages on successful connection


Resources:
	- XMPPFramework https://github.com/robbiehanson/XMPPFramework
	- https://adium.im/ can be used to test XMPP connection
	- XMPP Server: http://chatme.im
	serge@chatme.im
	serge2@chatme.im
  
Public XMPP servers
	https://list.jabber.at
