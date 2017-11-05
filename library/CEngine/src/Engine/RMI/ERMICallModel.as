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



public class ERMICallModel
{
    static private const __T : Array =[
    "CallModelSync",
    "CallModelAsync"];
    
    
    private static var __values : Array = new Array();
    public var __value : int;

    public static const _CallModelSync : int = 0;
    public static const CallModelSync : ERMICallModel  = new ERMICallModel(_CallModelSync);
    public static const _CallModelAsync : int = 1;
    public static const CallModelAsync : ERMICallModel  = new ERMICallModel(_CallModelAsync);

    public static function convert( val : int ) : ERMICallModel
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

    public function ERMICallModel( val : int )
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

    public static function __read( __is : SerializeStream ) : ERMICallModel
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 2)
        {
            throw new MarshalException();
        }
        return ERMICallModel.convert(__v);
    }
}
}
