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



public interface IFightPrx 
{
    function fight_async( __cb : AMI_IFight_fight, fightOper : SFightOper ) : void ;

    function setFightMode_async( __cb : AMI_IFight_setFightMode, mode : int ) : void ;

    function collect_async( __cb : AMI_IFight_collect, entityId : SEntityId , begin : Boolean ) : void ;

    function dispelBuffSelf_async( __cb : AMI_IFight_dispelBuffSelf) : void ;
}
}

