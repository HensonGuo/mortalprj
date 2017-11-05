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



public interface IGroupPrx 
{
    function groupOper_async( __cb : AMI_IGroup_groupOper, oper : Array ) : void ;

    function leftGroup_async( __cb : AMI_IGroup_leftGroup) : void ;

    function kickOut_async( __cb : AMI_IGroup_kickOut, entityId : SEntityId ) : void ;

    function modifyCaptain_async( __cb : AMI_IGroup_modifyCaptain, entityId : SEntityId ) : void ;

    function createGroup_async( __cb : AMI_IGroup_createGroup) : void ;

    function disbandGroup_async( __cb : AMI_IGroup_disbandGroup) : void ;

    function getGroupInfos_async( __cb : AMI_IGroup_getGroupInfos, entityIds : Array ) : void ;

    function updateGroupSetting_async( __cb : AMI_IGroup_updateGroupSetting, groupSetting : SGroupSetting ) : void ;
}
}

