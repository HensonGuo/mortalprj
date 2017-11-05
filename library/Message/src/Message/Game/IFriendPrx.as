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

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public interface IFriendPrx 
{
    function apply_async( __cb : AMI_IFriend_apply, player2Name : String ) : void ;

    function reply_async( __cb : AMI_IFriend_reply, playerIds : Array , result : int , type : int ) : void ;

    function removeAll_async( __cb : AMI_IFriend_removeAll, recordIds : Array , flag : int ) : void ;

    function moveIntoList_async( __cb : AMI_IFriend_moveIntoList, recordId : Number , fromList : int , toList : int ) : void ;

    function changeRemark_async( __cb : AMI_IFriend_changeRemark, recordId : Number , flag : int , remark : String ) : void ;

    function getFriendList_async( __cb : AMI_IFriend_getFriendList, flag : int ) : void ;

    function addToBlackList_async( __cb : AMI_IFriend_addToBlackList, playerId : int ) : void ;

    function getOneKeyMakeFriendsInfo_async( __cb : AMI_IFriend_getOneKeyMakeFriendsInfo) : void ;

    function oneKeyMakeFriends_async( __cb : AMI_IFriend_oneKeyMakeFriends, playerIds : Array ) : void ;

    function changeFriendType_async( __cb : AMI_IFriend_changeFriendType, recordId : Number , fromType : int , toType : int ) : void ;
}
}
