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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class AMI_IPlayer_getAttribute extends RMIObject
{
    public function AMI_IPlayer_getAttribute(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "getAttribute";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var combat : int;
        var baseFight : SFightAttribute;
        var extraFight : SFightAttribute;
        var addPercent : SFightAttributeAddPercent;
        var cellFight : SFightAttribute;
        try
        {
            combat = __is.readInt();
            baseFight = new SFightAttribute();
            baseFight.__read(__is);
            extraFight = new SFightAttribute();
            extraFight.__read(__is);
            addPercent = new SFightAttributeAddPercent();
            addPercent.__read(__is);
            cellFight = new SFightAttribute();
            cellFight.__read(__is);
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(combat, baseFight, extraFight, addPercent, cellFight);
    }

    public function cdeResponse(combat : int , baseFight : SFightAttribute , extraFight : SFightAttribute , addPercent : SFightAttributeAddPercent , cellFight : SFightAttribute ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , combat , baseFight , extraFight , addPercent , cellFight );
        }
    }
}
}

