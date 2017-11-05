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



public class EBusinessOperation
{
    public var __value : int;

    public static const _EBusinessOperationApply : int = 1;
    public static const _EBusinessOperationAgree : int = 2;
    public static const _EBusinessOperationUpdateMoney : int = 3;
    public static const _EBusinessOperationUpdateItem : int = 4;
    public static const _EBusinessOperationLock : int = 5;
    public static const _EBusinessOperationConfirm : int = 6;
    public static const _EBusinessOperationCancel : int = 7;
    public static const _EBusinessOperationError : int = 8;
    public static const _EBusinessOperationDeduct : int = 9;
    public static const _EBusinessOperationUnDeduct : int = 10;
    public static const _EBusinessOperationAdd : int = 11;
    public static const _EBusinessOperationEnd : int = 12;
    public static const _EBusinessOperationReject : int = 13;

    public static function convert( val : int ) : EBusinessOperation
    {
        return new EBusinessOperation( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EBusinessOperation( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EBusinessOperation
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 14)
        {
            throw new MarshalException();
        }
        return EBusinessOperation.convert(__v);
    }
}
}
