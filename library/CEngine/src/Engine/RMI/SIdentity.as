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


//[Bindable]
public class SIdentity
{
    public var name : String;

    public function SIdentity()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(name);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        name = __is.readString();
    }
}
}
