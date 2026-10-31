using System;
using System.IO;
using UndertaleModLib.Models;

// Adds one embedded song: Lil Godd — The 6 7 Song (audio index 25).
// The OGG is decoded from tools/custom/lilgodd.wav.b64 by the build.
EnsureDataLoaded();

string oggPath = "__WORKSPACE__/tools/custom/lilgodd.wav";
byte[] ogg = File.ReadAllBytes(oggPath);

var newAudio = new UndertaleEmbeddedAudio { Data = ogg };
Data.EmbeddedAudio.Add(newAudio);

var snd = new UndertaleSound
{
    Name = Data.Strings.MakeString("lilgodd"),
    Flags = UndertaleSound.AudioEntryFlags.IsEmbedded | UndertaleSound.AudioEntryFlags.Regular,
    File = Data.Strings.MakeString("lilgodd.ogg"),
    Volume = 1f,
    Pitch = 0f,
    GroupID = 0,
    AudioGroup = Data.AudioGroups[0],
    AudioFile = newAudio,
};
Data.Sounds.Add(snd);
ScriptMessage("added sound lilgodd at index " + (Data.Sounds.Count - 1));
