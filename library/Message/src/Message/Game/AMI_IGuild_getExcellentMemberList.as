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



public class AMI_IGuild_getExcellentMemberList extends RMIObject
{
    public function AMI_IGuild_getExcellentMemberList(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "getExcellentMemberList";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var excellentMembers : Array;
        try
        {
            excellentMembers = SeqSExcellentMemberHelper.read(__is);
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(excellentMembers);
    }

    public function cdeResponse(excellentMembers : Array ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , excellentMembers );
        }
    }
}
}
