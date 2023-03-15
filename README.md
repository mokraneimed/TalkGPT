# kyo

A new Flutter project.

## Getting Started

to use the app:
- install flutter
- clone the repo
- install the dependencies
- due to OpenAI rules, you have to use your own openAI secret key and put it in request.dart file in apiKey variable exactly line 6
- run the app
- the authentification is not ready yet, so to use the app press any button in the authentification page like "Sign in" button (like in the demo), and it will take you to the home page.


Talk GPT provides a voice chat with Chat GPT model using its API, where you press the mic button to put your voice as input using Speech_To_Text package in flutter, and you can change it if it doesn't look like what you want using the mic button also. After you confirm your input, you press the send button to send text to Chat GPT API with http request. LoadingIndicator will pop while you're waiting for the response. Using the Flutter_tts package, the text response will transform to voice and you can hear it with the text of course. Also we take in consideration that the user asks a question about the previous response. About the mail option, we show the user emails from his account (we haven't implemented it yet) and he can generate a response for any email using the "generate" button. If the response doesn't satisfy the user, he can generate another response. Also, we plan to add voice to generate other option (make the response shorter, make it more formal, ...). 

