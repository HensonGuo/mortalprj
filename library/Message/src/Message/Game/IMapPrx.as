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



public interface IMapPrx 
{
    function move_async( __cb : AMI_IMap_move, points : Array ) : void ;

    function diversion_async( __cb : AMI_IMap_diversion, points : Array ) : void ;

    function jump_async( __cb : AMI_IMap_jump, point : SPoint ) : void ;

    function somersault_async( __cb : AMI_IMap_somersault, points : Array ) : void ;

    function jumpPoint_async( __cb : AMI_IMap_jumpPoint, point : SPoint ) : void ;

    function pass_async( __cb : AMI_IMap_pass, type : EPassType , fromCode : int , toCode : int , point : SPoint ) : void ;

    function convey_async( __cb : AMI_IMap_convey, mapId : int , point : SPoint ) : void ;

    function revival_async( __cb : AMI_IMap_revival, type : int ) : void ;

    function pickup_async( __cb : AMI_IMap_pickup, entityId : SEntityId ) : void ;

    function saveCustomPoint_async( __cb : AMI_IMap_saveCustomPoint, index : int , name : String , mapId : int , point : SPoint ) : void ;

    function getCustomPoint_async( __cb : AMI_IMap_getCustomPoint) : void ;
}
}

