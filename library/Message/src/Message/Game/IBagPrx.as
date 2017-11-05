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



public interface IBagPrx 
{
    function get_async( __cb : AMI_IBag_get, posType : EPlayerItemPosType ) : void ;

    function tidy_async( __cb : AMI_IBag_tidy, posType : EPlayerItemPosType ) : void ;

    function use_async( __cb : AMI_IBag_use, uid : String , amount : int , values : Array ) : void ;

    function destroy_async( __cb : AMI_IBag_destroy, items : Array ) : void ;

    function sell_async( __cb : AMI_IBag_sell, items : Array ) : void ;

    function move_async( __cb : AMI_IBag_move, type : EMoveType , items : Array ) : void ;

    function split_async( __cb : AMI_IBag_split, uid : String , amount : int ) : void ;

    function open_async( __cb : AMI_IBag_open, posType : EPlayerItemPosType , amount : int , clientNeedMoney : int ) : void ;

    function openTime_async( __cb : AMI_IBag_openTime, posType : EPlayerItemPosType ) : void ;

    function repair_async( __cb : AMI_IBag_repair) : void ;
}
}

