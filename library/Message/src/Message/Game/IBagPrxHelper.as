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



public class IBagPrxHelper extends RMIProxyObject implements IBagPrx
{
    
    public static const NAME:String = "Message.Game.IBag";

    
    public function IBagPrxHelper()
    {
        name = "IBag";
    }

    public function destroy_async( __cb : AMI_IBag_destroy, items : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "destroy" );
        var __os : SerializeStream = new SerializeStream();
        SeqBagItemHelper.write(__os, items);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function get_async( __cb : AMI_IBag_get, posType : EPlayerItemPosType ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "get" );
        var __os : SerializeStream = new SerializeStream();
        posType.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function move_async( __cb : AMI_IBag_move, type : EMoveType , items : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "move" );
        var __os : SerializeStream = new SerializeStream();
        type.__write(__os);
        SeqBagItemHelper.write(__os, items);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function open_async( __cb : AMI_IBag_open, posType : EPlayerItemPosType , amount : int , clientNeedMoney : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "open" );
        var __os : SerializeStream = new SerializeStream();
        posType.__write(__os);
        __os.writeInt(amount);
        __os.writeInt(clientNeedMoney);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function openTime_async( __cb : AMI_IBag_openTime, posType : EPlayerItemPosType ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "openTime" );
        var __os : SerializeStream = new SerializeStream();
        posType.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function repair_async( __cb : AMI_IBag_repair) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "repair" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function sell_async( __cb : AMI_IBag_sell, items : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "sell" );
        var __os : SerializeStream = new SerializeStream();
        SeqBagItemHelper.write(__os, items);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function split_async( __cb : AMI_IBag_split, uid : String , amount : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "split" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(uid);
        __os.writeInt(amount);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function tidy_async( __cb : AMI_IBag_tidy, posType : EPlayerItemPosType ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "tidy" );
        var __os : SerializeStream = new SerializeStream();
        posType.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function use_async( __cb : AMI_IBag_use, uid : String , amount : int , values : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "use" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(uid);
        __os.writeInt(amount);
        SeqStringHelper.write(__os, values);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

