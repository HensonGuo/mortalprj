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



public interface IPlayerPrx 
{
    function findMiniPlayerById_async( __cb : AMI_IPlayer_findMiniPlayerById, playerIds : Array ) : void ;

    function findMiniPlayerByName_async( __cb : AMI_IPlayer_findMiniPlayerByName, playernames : Array ) : void ;

    function findPublicPlayerById_async( __cb : AMI_IPlayer_findPublicPlayerById, playerIds : Array ) : void ;

    function sendSignature_async( __cb : AMI_IPlayer_sendSignature, signature : String ) : void ;

    function getPlayerSoul_async( __cb : AMI_IPlayer_getPlayerSoul, playerId : int ) : void ;

    function getSoulTime_async( __cb : AMI_IPlayer_getSoulTime, playerId : int ) : void ;

    function activeSoul_async( __cb : AMI_IPlayer_activeSoul, playerId : int , itemCode : int ) : void ;

    function upgradeSoul_async( __cb : AMI_IPlayer_upgradeSoul, playerId : int , soul : int , node : int , level : int ) : void ;

    function putOutSoul_async( __cb : AMI_IPlayer_putOutSoul, playerId : int , soul : int ) : void ;

    function callInSoul_async( __cb : AMI_IPlayer_callInSoul, playerId : int , soul : int ) : void ;

    function reduceUpgradeSoul_async( __cb : AMI_IPlayer_reduceUpgradeSoul, playerId : int , time : int ) : void ;

    function getAttribute_async( __cb : AMI_IPlayer_getAttribute) : void ;
}
}

