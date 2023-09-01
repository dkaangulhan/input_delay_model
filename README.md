# input_delay_model
Flutter repo for helping developers to delay consecutive async operations until, for example, stopping typing text.

## Example use case
Here I am searching text in an API where users can type too fast where too many API calls can occur, which can have your limit to exceed.
```
Future search({
    required String url,
  }) async {
    InputDelayModel inputDelayModel = InputDelayModel.getModel('MODEL_KEY');

    ///  This line calls on every tap to a key on keyboard. If duration is not
    ///  exceeded API request won't be executed. If user stop to tap to keyboard
    ///  and, in this case 500ms, is passed, then API request is executed.
    inputDelayModel.start(
      cb: (idTimer) async {
        final response = await searchService.search(
            args: textEditingController.text);
        
        ///  This line ensures that, for example, API request is sent but
        ///  while request is on WEB and user tapped again, then incoming
        ///  data of previous result won't be saved.
        ///  `result` and `response` is fields, that is used in my code, which is not important here.
        ///  Main point here is `InputDelayStatus` check and according to status attaching result.
        if (idTimer.status != InputDelayStatus.canceled) {
          _result.value = response.data ?? [];
        }
      },
    );
  }
```
