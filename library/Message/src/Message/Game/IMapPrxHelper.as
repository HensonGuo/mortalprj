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



public class IMapPrxHelper extends RMIProxyObject implements IMapPrx
{
    
    public static const NAME:String = "Message.Game.IMap";

    
    public function IMapPrxHelper()
    {
        name = "IMap";
    }

    public function convey_async( __cb : AMI_IMap_convey, mapId : int , point : SPoint ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "convey" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(mapId);
        point.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function diversion_async( __cb : AMI_IMap_diversion, points : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "diversion" );
        var __os : SerializeStream = new SerializeStream();
        SeqPointHelper.write(__os, points);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getCustomPoint_async( __cb : AMI_IMap_getCustomPoint) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getCustomPoint" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function jump_async( __cb : AMI_IMap_jump, point : SPoint ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "jump" );
        var __os : SerializeStream = new SerializeStream();
        point.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function jumpPoint_async( __cb : AMI_IMap_jumpPoint, point : SPoint ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "jumpPoint" );
        var __os : SerializeStream = new SerializeStream();
        point.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function move_async( __cb : AMI_IMap_move, points : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "move" );
        var __os : SerializeStream = new SerializeStream();
        SeqPointHelper.write(__os, points);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function pass_async( __cb : AMI_IMap_pass, type : EPassType , fromCode : int , toCode : int , point : SPoint ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "pass" );
        var __os : SerializeStream = new SerializeStream();
        type.__write(__os);
        __os.writeInt(fromCode);
        __os.writeInt(toCode);
        point.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function pickup_async( __cb : AMI_IMap_pickup, entityId : SEntityId ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "pickup" );
        var __os : SerializeStream = new SerializeStream();
        entityId.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function revival_async( __cb : AMI_IMap_revival, type : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "revival" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(type);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function saveCustomPoint_async( __cb : AMI_IMap_saveCustomPoint, index : int , name : String , mapId : int , point : SPoint ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "saveCustomPoint" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(index);
        __os.writeString(name);
        __os.writeInt(mapId);
        point.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function somersault_async( __cb : AMI_IMap_somersault, points : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "somersault" );
        var __os : SerializeStream = new SerializeStream();
        SeqPointHelper.write(__os, points);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

