SwiftIB
=======

SwiftIB is a pure Swift implementation of the [Interactive Brokers](https://www.interactivebrokers.com/) [TWS API](https://www.interactivebrokers.com/en/software/api/api.htm) library on Mac OS X, with Core Foundation of crouse. All the API interfaces are implemented. `Request Market Data` and `Request History Data` interface are thoroughly tested.

Along with SwiftIB there are `HistoryDataDump` and `MktDataDump` command line applications as references for using SwiftIB library. Currently SwiftIB does not support static linking, and command line applications cannot use Framework distribution conveniently. So these tools are compiled with SwiftIB sources directly. 

Should you have any suggestion or comments, the author will be glad to hear them 😄


----

```
Disclaimer: 

This software is in no way affiliated, endorsed, or approved by Interactive Brokers or 
any of its affiliates. It comes with absolutely no warranty and should not be used in
actual trading unless the user can read and understand the source.
```

    

