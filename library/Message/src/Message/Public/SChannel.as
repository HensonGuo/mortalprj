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


public class SChannel
{
    public var id : int;

    public var type : int;

    public var status : int;

    public var pUrl : String;

    public var pid : int;

    public var name : String;

    public var publicBindUrl : String;

    public var publicUrl : String;

    public var privateUrl : String;

    public function SChannel()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(id);
        __os.writeInt(type);
        __os.writeInt(status);
        __os.writeString(pUrl);
        __os.writeInt(pid);
        __os.writeString(name);
        __os.writeString(publicBindUrl);
        __os.writeString(publicUrl);
        __os.writeString(privateUrl);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        id = __is.readInt();
        type = __is.readInt();
        status = __is.readInt();
        pUrl = __is.readString();
        pid = __is.readInt();
        name = __is.readString();
        publicBindUrl = __is.readString();
        publicUrl = __is.readString();
        privateUrl = __is.readString();
    }
}
}
