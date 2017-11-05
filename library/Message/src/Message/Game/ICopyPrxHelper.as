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



public class ICopyPrxHelper extends RMIProxyObject implements ICopyPrx
{
    
    public static const NAME:String = "Message.Game.ICopy";

    
    public function ICopyPrxHelper()
    {
        name = "ICopy";
    }

    public function copyWaitingRoomOper_async( __cb : AMI_ICopy_copyWaitingRoomOper, copyCode : int , oper : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "copyWaitingRoomOper" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(copyCode);
        __os.writeInt(oper);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function enterCopy_async( __cb : AMI_ICopy_enterCopy, copyCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "enterCopy" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(copyCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function enterHall_async( __cb : AMI_ICopy_enterHall, copyCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "enterHall" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(copyCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getCopyWaitingRoomInfo_async( __cb : AMI_ICopy_getCopyWaitingRoomInfo, copyCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getCopyWaitingRoomInfo" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(copyCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function leftCopy_async( __cb : AMI_ICopy_leftCopy) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "leftCopy" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function leftHall_async( __cb : AMI_ICopy_leftHall) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "leftHall" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function reEnterCopy_async( __cb : AMI_ICopy_reEnterCopy) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "reEnterCopy" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function viewGroup_async( __cb : AMI_ICopy_viewGroup, copyCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "viewGroup" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(copyCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}
