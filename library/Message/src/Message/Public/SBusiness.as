// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Public{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SBusiness extends IMessageBase 
{
    public var operation : EBusinessOperation;

    public var fromEntity : SEntityId;

    public var businessId : String;

    public var endDt : Date;

    public var error : SErrorMsg;

    public var fromInfo : SBusinessInfo;

    public var toInfo : SBusinessInfo;

    public function SBusiness(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SBusiness = new SBusiness( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 13501;

    override public function clone() : IMessageBase
    {
        return new SBusiness;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        operation.__write(__os);
        fromEntity.__write(__os);
        __os.writeString(businessId);
        __os.writeDate(endDt);
        error.__write(__os);
        fromInfo.__write(__os);
        toInfo.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        operation = EBusinessOperation.__read(__is);
        fromEntity = new SEntityId();
        fromEntity.__read(__is);
        businessId = __is.readString();
        endDt = __is.readDate();
        error = new SErrorMsg();
        error.__read(__is);
        fromInfo = new SBusinessInfo();
        fromInfo.__read(__is);
        toInfo = new SBusinessInfo();
        toInfo.__read(__is);
    }
}
}
