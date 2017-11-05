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

import Framework.Holder.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.Exception;



public class AMI_IKeepActive_keepActive extends RMIObject
{
    public virtual function cdeResponse() : void
    {
    	name = 'IKeepActive';
    	callFunction = "keepActive";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        try
        {
        }
        catch( __ex : Exception )
        {
            cdeException(__ex);
            return;
        }
        cdeResponse();
    }
}
}
