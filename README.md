# FragileMemory

This is the repository of 2nd Semester Project, Fragile Memory is the project we built.


##Project Concept

First of all, we got a topic about memory. Then we search some research about the memory. we find that the fragile memory. It is a good topic which we can develop it a lot. We want to add a freak memory to the others. The VR technology is a very good choice to make a virtual reality experience for humanity. The world in the VR is not real, and the memory we make is not real too. These two things have the same parts.
We want to let audience have a fragile memory though the experience which we prove. The world in VR is same as the reality, but also has some difference.


##Tools we used
(The environment we built the project is under Windows 10, Mac OS X 0.9.5)

###SOFTWARE PARTS
1. Unity3D v5.3.4
Plug-ins:
  (1) Simple Web Sockets for Unity WebGL:https://www.assetstore.unity3d.com/en/#!/content/38367
  (2) EasyMovieTexture:https://www.assetstore.unity3d.com/en/#!/content/10032
2. OpenFrameworks v0.9.3
Library: ofxLibwebsockets:https://github.com/robotconscience/ofxLibwebsockets
3. Processing 3.1.2
Libraries:
  (1) ThinkGear.jar (Already Include in the repository)
  (2) WebSockets (Downloaded in Tools-Add Library-WebSockets)
4. Adobe After Effects cc 2015

###HARDWARE PARTS
1. Oculus Rift DK2 / HTC VIVE //Not Sure
2. insta360 nano (taking 3040*1520 resolution panoramic video)
3. PC / MAC laptop


##Step 1

 We're trying to use official ThinkGear Native Library in Unity3D.
 http://developer.neurosky.com/docs/doku.php?id=using_thinkgear_with_unity
 (1) Install Develop tools for platform: http://store.neurosky.com/collections/developer-tools
 (2) Install ThinkGear Connector: http://developer.neurosky.com/docs/doku.php?id=thinkgear_connector_tgc
 (3) Download Unity3D package: http://neurosky.fetchapp.com/permalink/uchoob

 Open the package in Unity3D, run the demo:
 (1) Drag the NeuroSkyTGCController prefab from Project view to Hierarchy view
 (2) Add the DisplayData.cs to main Camera
 (3) Play UnityEditor,it will auto connect TGC
 (4) You can click Disconnect button to disconnect
 (5) You can click Connect button to re-connect

 But it seems it connect auto connect TGC.

##Step 2

 After a discussion, we've found out the we could build a bridge through WebSockets by using Processing and Unity. But first, we have to test with building a client and server with OpenFrameworks and Processing.
 (1) Using projectGenerator to generate a default project for using and open in IDE.
 (2) Write : // (NEED THE SOURCE CODE) in Main.cpp
 (3) Save and Run in IDE, open Processing, write down the code for the client.

````
import websockets.*;
WebsocketClient client;
String address;
int startTime;
int timeLimit;

void setup(){
 size(600,600);
 address = "ws://192.168.1.192:9091";
 client = new WebsocketClient(this, address);
 timeLimit = 1000;
 startTime = millis();
}

void draw(){
 if(millis()>startTime+timeLimit){
   int data = int(random(0,100));
    client.sendMessage(str(data));
 }
 }
void webSocketEvent(String m){
 println(m);
}
````
 (4) Then we built up the connection through Unity3D and Processing. We went to assetstore to download the WebSockets asset. There's an example called Echo.unity & Echo.c#. Unity3D(client) has to send a blank message to Processing(server) and call for echo, then the server will send the message back. This is what we called "handshake" process. Handshake process happens the very first time connected with the client and the server, it was happened before data transformation.

````
using UnityEngine;
using System.Collections;
using System;

public class EchoTest : MonoBehaviour {

	// Use this for initialization
	IEnumerator Start () {
		WebSocket w = new WebSocket(new Uri("ws://192.168.1.208:9091"));   

    //YOU SHOULD CHECK THE SERVER'S IP ADDRESS, HERE IS 192.168.1.208.

		yield return StartCoroutine(w.Connect());
		//w.SendString("hello world");
		//int i=0;
		while (true)
		{
			string reply = w.RecvString();
			if (reply != null)
			{
				Debug.Log ("Received: "+reply);
				//w.SendString("Hi there"+i++);
				//w.SendString("300");
			}
			if (w.error != null)
			{
				Debug.LogError ("Error: "+w.error);
				break;
			}
			yield return 0;
		}
		w.Close();
	}
}
````

(5) At this point, we tested with random number between 0 - 100. Then we have to figure out how to use Nerosky Mindwave Data to processing. We install 2 Libraries for processing, one is WebSocket and the other is nerosky( You can clone the .jar file to the sketch so it can be installed directly.). Open the sketch we have in the repository and open your ThinkGear Connector (It works with bluetooth, you have to pair in RED light and connecing in still BLUE light). Run the sketch and see your attentionLevel and your meditationLevel.

(6) Open the Unity and loading Echo.unity, click the "PLAY" button and see the data through Processing.(You have to keep the ThinkGear Connector, Processing Sketch and Unity on).

##Step 3

(1) We download the tutorial from http://blog.csdn.net/shenmifangke/article/details/50637074 which offer good way to play panoramic video in a sphere object.With a official MovieTexture, we can easily replace the video we took to the material. Assets we used: FirstPersonController, EchoTest(the one we created to connect neurosky).

(2) We carefully made the after effects to the videos, which created 7 results with different effects, we thought this is the best way to create immersive effect.

(3) We have to combine the neurosky Received data to control the videos.
So we have to convert the String data to Int data. Import those videos to the materials, and those materials will apply to the "Sphere" with blend the material into a ball, we put the camera inside the Sphere, so this can create the cool immersive effect.
AAA material means the 1st Material and the BBB,CCC,DDD means the other videos.
````
out_reply = Convert.ToInt32(reply);
````

Then our combination is here:
````
using UnityEngine;
using System.Collections;
using System;

public class NewBehaviourScript : MonoBehaviour
{
    public Material aaa;
    public Material bbb;
    public int result;
    //public MovieTexture movie;
    public int out_reply;

    //把图片换成视频就能播放了
    void Start()
    {
        //MovieTexture movie;
        result = out_reply;
        //result = UnityEngine.Random.Range(1, 100);

    }

    IEnumerator echoStart()
    {
        WebSocket w = new WebSocket(new Uri("ws://192.168.102.29:9091"));
        yield return StartCoroutine(w.Connect());
        w.SendString("Hi there");
        int i = 0;
        while (true)
        {
            string reply = w.RecvString();


            if (reply != null)
            {
                Debug.Log("Received: " + reply);
                out_reply = Convert.ToInt32(reply);
                Debug.Log("Out_Received: " + out_reply);
                w.SendString("Hi there" + i++);

            }
            if (w.error != null)
            {
                Debug.LogError("Error: " + w.error);
                break;
            }
            yield return 0;
        }
        w.Close();
    }


    void Update()
    {

        MovieTexture movie;
        if (result < 50)
        {
            if (aaa.mainTexture as MovieTexture)
            {
                movie = (MovieTexture)aaa.mainTexture;
                movie.Play();
            }
        }
        else
        {
            //movie.Stop();
        }
        if (result > 50)
        {
            if (bbb.mainTexture as MovieTexture)
            {
                movie = (MovieTexture)bbb.mainTexture;
                movie.Play();
            }
        }
        else
        {
           // movie.Stop();
        }
    }

}
````
However, there is one problem, after we test with the code we've wrote and asked some teachers who can help us to switching videos with data, we still can't switch the videos.

(4) Unity gives a good way to render the program, we can easily render the program with the official tools to create PC, IOS and Android program. You can download the source code and try to solve our problem!


Thanks for watching!
