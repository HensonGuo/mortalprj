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



public class IFriendPrxHelper extends RMIProxyObject implements IFriendPrx
{
    
    public static const NAME:String = "Message.Game.IFriend";

    
    public function IFriendPrxHelper()
    {
        name = "IFriend";
    }

    public function addToBlackList_async( __cb : AMI_IFriend_addToBlackList, playerId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "addToBlackList" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function apply_async( __cb : AMI_IFriend_apply, player2Name : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "apply" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(player2Name);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function changeFriendType_async( __cb : AMI_IFriend_changeFriendType, recordId : Number , fromType : int , toType : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "changeFriendType" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeLong(recordId);
        __os.writeInt(fromType);
        __os.writeInt(toType);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function changeRemark_async( __cb : AMI_IFriend_changeRemark, recordId : Number , flag : int , remark : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "changeRemark" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeLong(recordId);
        __os.writeInt(flag);
        __os.writeString(remark);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getFriendList_async( __cb : AMI_IFriend_getFriendList, flag : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getFriendList" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(flag);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getOneKeyMakeFriendsInfo_async( __cb : AMI_IFriend_getOneKeyMakeFriendsInfo) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getOneKeyMakeFriendsInfo" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function moveIntoList_async( __cb : AMI_IFriend_moveIntoList, recordId : Number , fromList : int , toList : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "moveIntoList" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeLong(recordId);
        __os.writeInt(fromList);
        __os.writeInt(toList);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function oneKeyMakeFriends_async( __cb : AMI_IFriend_oneKeyMakeFriends, playerIds : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "oneKeyMakeFriends" );
        var __os : SerializeStream = new SerializeStream();
        SeqIntHelper.write(__os, playerIds);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function removeAll_async( __cb : AMI_IFriend_removeAll, recordIds : Array , flag : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "removeAll" );
        var __os : SerializeStream = new SerializeStream();
        SeqLongHelper.write(__os, recordIds);
        __os.writeInt(flag);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function reply_async( __cb : AMI_IFriend_reply, playerIds : Array , result : int , type : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "reply" );
        var __os : SerializeStream = new SerializeStream();
        SeqIntHelper.write(__os, playerIds);
        __os.writeInt(result);
        __os.writeInt(type);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

