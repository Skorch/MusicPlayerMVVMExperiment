MusicPlayerMVVMExperiment
=========================

Experimental use of AFIncrementalStore and Reactive Cocoa to produce the MVVM pattern

Makes use of Core Data, AVFoundation, Reactive Cocoa, AFIncrementalStore, AFNetworking.

The experiment was to explore the concept of using AFIncrementalStore to handle JSON/REST mappings 
and Core Data/Incremental Store to cache the results and cause cache faults which lead to further 
API requests.

The other experiment was to explore the capabilities of Reactive Cocoa and the concepts of the 
MVVM pattern within the MVC world of Cocoa.  The idea is that the rules for composing and mapping
the model data is abstracted into a ViewModel which leaves the view/controller free to focus
purely on the UI/UX.