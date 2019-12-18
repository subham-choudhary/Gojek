# Gojek

This is an assignment given by Gojek
Please do a pod install and then open the AssignmentGojek.xcworkspace file.

About the App:

Since, It is a contacts app, user can use it when there is no internet connection. So I decided to save the contact locally in efficient manner. 

I am avoiding the loader as much as possible so the user will get a decent experience.

I wanted to built a job scheduler which will save the all api in a queue. For scenarios like no internet or app closed.  Due to less time I did not implemented it.

I am not much experienced in UI / Unit testing. But still have learnt in short time and implemented it.



#Splash screen

On the first launch, I am calling the api which is returning me all the Contacts, and saving it to the realm. file

On next launch, I am calling the same API but not saving the whole response to the Realm. I am checking the new added, deleted and  updated contacts.

If API fails it will still move to the next screen. Showing previously downloaded contacts.


#Contacts Listing screen


To give users a good experience, I am retrieving details of all the user you can see in the screen in advance. There is a shimmer effect to show the contacts are loading.


#Edit Contacts/Create Contact screen

I am reusing the same VC for editing and creating contacts.

I am not doing the validation because API it is handling them, and we can change the validation rule anytime from the backend.

