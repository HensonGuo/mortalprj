// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Game{

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class IPlayerPrxHelper extends RMIProxyObject implements IPlayerPrx
{
    
    public static const NAME:String = "Message.Game.IPlayer";

    
    public function IPlayerPrxHelper()
    {
        name = "IPlayer";
    }

    public function activeSoul_async( __cb : AMI_IPlayer_activeSoul, playerId : int , itemCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "activeSoul" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeInt(itemCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function callInSoul_async( __cb : AMI_IPlayer_callInSoul, playerId : int , soul : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "callInSoul" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeInt(soul);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function findMiniPlayerById_async( __cb : AMI_IPlayer_findMiniPlayerById, playerIds : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "findMiniPlayerById" );
        var __os : SerializeStream = new SerializeStream();
        SeqIntHelper.write(__os, playerIds);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function findMiniPlayerByName_async( __cb : AMI_IPlayer_findMiniPlayerByName, playernames : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "findMiniPlayerByName" );
        var __os : SerializeStream = new SerializeStream();
        SeqStringHelper.write(__os, playernames);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function findPublicPlayerById_async( __cb : AMI_IPlayer_findPublicPlayerById, playerIds : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "findPublicPlayerById" );
        var __os : SerializeStream = new SerializeStream();
        SeqIntHelper.write(__os, playerIds);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getAttribute_async( __cb : AMI_IPlayer_getAttribute) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getAttribute" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getPlayerSoul_async( __cb : AMI_IPlayer_getPlayerSoul, playerId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getPlayerSoul" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getSoulTime_async( __cb : AMI_IPlayer_getSoulTime, playerId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getSoulTime" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function putOutSoul_async( __cb : AMI_IPlayer_putOutSoul, playerId : int , soul : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "putOutSoul" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeInt(soul);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function reduceUpgradeSoul_async( __cb : AMI_IPlayer_reduceUpgradeSoul, playerId : int , time : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "reduceUpgradeSoul" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeInt(time);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function sendSignature_async( __cb : AMI_IPlayer_sendSignature, signature : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "sendSignature" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(signature);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function upgradeSoul_async( __cb : AMI_IPlayer_upgradeSoul, playerId : int , soul : int , node : int , level : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "upgradeSoul" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeInt(soul);
        __os.writeInt(node);
        __os.writeInt(level);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

