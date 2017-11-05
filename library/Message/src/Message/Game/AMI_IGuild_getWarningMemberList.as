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



public class AMI_IGuild_getWarningMemberList extends RMIObject
{
    public function AMI_IGuild_getWarningMemberList(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "getWarningMemberList";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var warningMembers : Array;
        try
        {
            warningMembers = SeqSWarningMemberHelper.read(__is);
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(warningMembers);
    }

    public function cdeResponse(warningMembers : Array ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , warningMembers );
        }
    }
}
}
