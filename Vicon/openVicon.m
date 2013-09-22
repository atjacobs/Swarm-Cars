global MyClient;
Client.LoadViconDataStreamSDK();
MyClient = Client();
MyClient.Connect('localhost');
MyClient.EnableSegmentData();
MyClient.EnableMarkerData();
MyClient.EnableUnlabeledMarkerData();
MyClient.EnableDeviceData();
MyClient.SetStreamMode( StreamMode.ClientPull );
MyClient.SetAxisMapping( Direction.Forward, ...
                         Direction.Left,    ...
                         Direction.Up ); 