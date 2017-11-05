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



public class AMI_IEquip_strengthen extends RMIObject
{
    public function AMI_IEquip_strengthen(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "strengthen";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var resultEquip : SPlayerItem;
        var consumes : Array;
        var __ret : int;
        try
        {
            resultEquip = new SPlayerItem();
            resultEquip.__read(__is);
            consumes = SeqEquipConsumeHelper.read(__is);
            __ret = __is.readInt();
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(__ret, resultEquip, consumes);
    }

    public function cdeResponse( __ret : int, resultEquip : SPlayerItem , consumes : Array ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , __ret , resultEquip , consumes );
        }
    }
}
}

