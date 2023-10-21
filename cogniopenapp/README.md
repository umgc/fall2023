# CogniOpen

The CogniOpen (FKA 'RemindMe!') application for the UMGC Capstone - SWEN 670 fall2023 cohort submission.

## Getting Started

1. Run `flutter pub get` to install dependencies
2. Run `flutter emulators --launch <emulator_id>` to start the emulator device. For example, `flutter emulators --launch Pixel_5_API_34`
 - Use `flutter emulators` to get a list of emulator ids.
3. Run `flutter run` to run the application in the emulated environment.

# Using the .env file

The .env file will store environmental (and other secret) variables used in the development and execution of the application functions. See the `temp-env` file with variables to fill in.
For example, the ChatGPT access token variable will be stored here to access the ChatGPT API (used in various audio transcription related features). Likewise, the AWS S3 and Rekognition accessKeys are also stored in this file.

This .env file IS NOT to be checked into the source code repo. Before committing code, please ensure that your .env file is not being pushed into the branches; similarly, ensure that the .gitignore file include ` *.env` so that this .env file will never be uploaded to the repository.

# Getting the OpenAI ChatGPT API Key

The following outlines setting up a new key and adding it to the .env created with the instructions above.

1. Go to https://openai.com and Login or Sign up for a new account. 
2. Click on API
3. At top right, click on Personal and then View API Keys menu item.
4. Click "+ Create new secret key" button
5. Give the key a name, relating to CogniOpen or SWEN670
6. The new secret key will appear in a text box with copy button next to it.
7. Copy the key and paste it into your .env file.
8. Save the key somewhere like OneNote where it will be safe, you cannot retrieve this key once you close this dialog. You can however make more.
9. Click done.


# Getting the AWS access key

1. Go to https://aws.amazon.com/ and select "Sign In" to sign in or create a new "Free Tier" account
2. Once you are at the console home, navigate to your account and then "Security credentials"
3. Select "Users" and then "Create user"
4. Give the user a name. Select "next" to move to "Step 2: Set permissions"
5. Select "attach policies directly". Then select the "AdministratorAccess-Amplify", "AmazonRekognitionFullAccess", "AmazonKinesisFullAccess", "AmazonS3FullAccess", and "AmazonTranscribeFullAccess" permission policies
6. Select "Create user" in "Step 3: Review and create".
 The new secret key will appear in a text box with copy button next to it.
7. Copy the accesskey and paste it into your .env file.
8. Copy the secretKey and paste it into your .env file.
9. Save the key somewhere like OneNote where it will be safe, you cannot retrieve this key once you close this dialog. You can however make more.
10. Click done.

The Amazon Free tier ought to have enough space and video processing requests to complete development and testing. Just be aware of video fidelity and length when recording.
Requests are pretty cheap afterwards but the dollar amount can pile up if unaware.