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



public class AMI_IMail_queryMail extends RMIObject
{
    public function AMI_IMail_queryMail(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "queryMail";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var outMails : Array;
        var outStartIndex : int;
        var outTotalCount : int;
        try
        {
            outMails = SeqMailHelper.read(__is);
            outStartIndex = __is.readInt();
            outTotalCount = __is.readInt();
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(outMails, outStartIndex, outTotalCount);
    }

    public function cdeResponse(outMails : Array , outStartIndex : int , outTotalCount : int ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , outMails , outStartIndex , outTotalCount );
        }
    }
}
}
