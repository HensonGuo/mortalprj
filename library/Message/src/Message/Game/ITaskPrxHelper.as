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



public class ITaskPrxHelper extends RMIProxyObject implements ITaskPrx
{
    
    public static const NAME:String = "Message.Game.ITask";

    
    public function ITaskPrxHelper()
    {
        name = "ITask";
    }

    public function cancelTask_async( __cb : AMI_ITask_cancelTask, taskCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "cancelTask" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(taskCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function digTreasure_async( __cb : AMI_ITask_digTreasure) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "digTreasure" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function dramaStep_async( __cb : AMI_ITask_dramaStep, step : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "dramaStep" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(step);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function endTask_async( __cb : AMI_ITask_endTask, npc : int , taskCode : int , choose : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "endTask" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(npc);
        __os.writeInt(taskCode);
        __os.writeInt(choose);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function explore_async( __cb : AMI_ITask_explore) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "explore" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getTask_async( __cb : AMI_ITask_getTask, npc : int , taskCode : int , choose : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getTask" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(npc);
        __os.writeInt(taskCode);
        __os.writeInt(choose);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function npcTask_async( __cb : AMI_ITask_npcTask, npc : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "npcTask" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(npc);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function quickCompleteTask_async( __cb : AMI_ITask_quickCompleteTask, taskCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "quickCompleteTask" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(taskCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function talkToNpc_async( __cb : AMI_ITask_talkToNpc, taskCode : int , npc : int , code : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "talkToNpc" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(taskCode);
        __os.writeInt(npc);
        __os.writeInt(code);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function taskInfo_async( __cb : AMI_ITask_taskInfo, taskCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "taskInfo" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(taskCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}
