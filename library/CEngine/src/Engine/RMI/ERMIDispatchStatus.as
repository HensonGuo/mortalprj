// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Engine.RMI{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;



public class ERMIDispatchStatus
{
    static private const __T : Array =[
    "DispatchOK",
    "DispatchTimeOut",
    "DispatchException",
    "DispatchObjectNotExist",
    "DispatchOperationNotExist",
    "DispatchAsync"];
    
    
    private static var __values : Array = new Array();
    public var __value : int;

    public static const _DispatchOK : int = 0;
    public static const DispatchOK : ERMIDispatchStatus  = new ERMIDispatchStatus(_DispatchOK);
    public static const _DispatchTimeOut : int = 1;
    public static const DispatchTimeOut : ERMIDispatchStatus  = new ERMIDispatchStatus(_DispatchTimeOut);
    public static const _DispatchException : int = 2;
    public static const DispatchException : ERMIDispatchStatus  = new ERMIDispatchStatus(_DispatchException);
    public static const _DispatchObjectNotExist : int = 3;
    public static const DispatchObjectNotExist : ERMIDispatchStatus  = new ERMIDispatchStatus(_DispatchObjectNotExist);
    public static const _DispatchOperationNotExist : int = 4;
    public static const DispatchOperationNotExist : ERMIDispatchStatus  = new ERMIDispatchStatus(_DispatchOperationNotExist);
    public static const _DispatchAsync : int = 5;
    public static const DispatchAsync : ERMIDispatchStatus  = new ERMIDispatchStatus(_DispatchAsync);

    public static function convert( val : int ) : ERMIDispatchStatus
    {
        return __values[val];
    }

    public function value() : int
    {
        return __value;
    }

    public function toString() : String
    {
        return __T[__value];
    }

    public function ERMIDispatchStatus( val : int )
    {
        __value = val;
        __values[val] = this;
    }

    public function equals( rhs : Object ) : Boolean 
    {
        if(this == rhs)
        {
            return true;
        }
        var _rs : ERMICallModel = rhs as ERMICallModel;
        if( _rs == null ) 
            return false;
        return this.__value == _rs.value();
    }

    public function hashCode():int
    {
        return 5 * __value;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ERMIDispatchStatus
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 6)
        {
            throw new MarshalException();
        }
        return ERMIDispatchStatus.convert(__v);
    }
}
}
