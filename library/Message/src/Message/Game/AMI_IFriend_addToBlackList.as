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



public class AMI_IFriend_addToBlackList extends RMIObject
{
    public function AMI_IFriend_addToBlackList(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "addToBlackList";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        cdeResponse();
    }

    public function cdeResponse() : void
    {
        if( null != _response )
        {
            _response.call( null , this );
        }
    }
}
}
