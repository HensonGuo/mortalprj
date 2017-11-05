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



public class IGroupPrxHelper extends RMIProxyObject implements IGroupPrx
{
    
    public static const NAME:String = "Message.Game.IGroup";

    
    public function IGroupPrxHelper()
    {
        name = "IGroup";
    }

    public function createGroup_async( __cb : AMI_IGroup_createGroup) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "createGroup" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function disbandGroup_async( __cb : AMI_IGroup_disbandGroup) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "disbandGroup" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getGroupInfos_async( __cb : AMI_IGroup_getGroupInfos, entityIds : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getGroupInfos" );
        var __os : SerializeStream = new SerializeStream();
        SeqEntityIdHelper.write(__os, entityIds);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function groupOper_async( __cb : AMI_IGroup_groupOper, oper : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "groupOper" );
        var __os : SerializeStream = new SerializeStream();
        SeqGroupOperHelper.write(__os, oper);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function kickOut_async( __cb : AMI_IGroup_kickOut, entityId : SEntityId ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "kickOut" );
        var __os : SerializeStream = new SerializeStream();
        entityId.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function leftGroup_async( __cb : AMI_IGroup_leftGroup) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "leftGroup" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function modifyCaptain_async( __cb : AMI_IGroup_modifyCaptain, entityId : SEntityId ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "modifyCaptain" );
        var __os : SerializeStream = new SerializeStream();
        entityId.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function updateGroupSetting_async( __cb : AMI_IGroup_updateGroupSetting, groupSetting : SGroupSetting ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "updateGroupSetting" );
        var __os : SerializeStream = new SerializeStream();
        groupSetting.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

