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



public class AMI_IMount_upgradeTool extends RMIObject
{
    public function AMI_IMount_upgradeTool(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "upgradeTool";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var randValue : Array;
        var toolExpMap : Dictionary;
        try
        {
            randValue = SeqIntHelper.read(__is);
            toolExpMap = DictIntIntHelper.read(__is);
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(randValue, toolExpMap);
    }

    public function cdeResponse(randValue : Array , toolExpMap : Dictionary ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , randValue , toolExpMap );
        }
    }
}
}

