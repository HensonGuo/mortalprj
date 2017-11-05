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



public class IEquipPrxHelper extends RMIProxyObject implements IEquipPrx
{
    
    public static const NAME:String = "Message.Game.IEquip";

    
    public function IEquipPrxHelper()
    {
        name = "IEquip";
    }

    public function equipColorAdvance_async( __cb : AMI_IEquip_equipColorAdvance, equipUid : String , operatortype : EOperType , autoBuy : Boolean , priorityFlag : EPriorityType ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "equipColorAdvance" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(equipUid);
        operatortype.__write(__os);
        __os.writeBool(autoBuy);
        priorityFlag.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function equipDecompose_async( __cb : AMI_IEquip_equipDecompose, equipUid : String , priority : EPriorityType ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "equipDecompose" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(equipUid);
        priority.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function equipQualityAdvance_async( __cb : AMI_IEquip_equipQualityAdvance, equipUid : String , operatortype : EOperType , autoBuy : Boolean , priorityFlag : EPriorityType ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "equipQualityAdvance" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(equipUid);
        operatortype.__write(__os);
        __os.writeBool(autoBuy);
        priorityFlag.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function equipRefresh_async( __cb : AMI_IEquip_equipRefresh, equipUid : String , type : EOperType , autoBuy : Boolean , priorityFlag : EPriorityType , lockDict : Dictionary , expectAttr : Dictionary , expectAttrAll : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "equipRefresh" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(equipUid);
        type.__write(__os);
        __os.writeBool(autoBuy);
        priorityFlag.__write(__os);
        DictIntIntHelper.write(__os, lockDict);
        DictIntIntHelper.write(__os, expectAttr);
        __os.writeInt(expectAttrAll);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function equipRefreshReplace_async( __cb : AMI_IEquip_equipRefreshReplace, equipUid : String , replaceIndex : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "equipRefreshReplace" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(equipUid);
        __os.writeInt(replaceIndex);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function jewelDecompose_async( __cb : AMI_IEquip_jewelDecompose, jewelUids : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "jewelDecompose" );
        var __os : SerializeStream = new SerializeStream();
        SeqStringHelper.write(__os, jewelUids);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function jewelEmbed_async( __cb : AMI_IEquip_jewelEmbed, equipUid : String , materials : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "jewelEmbed" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(equipUid);
        SeqStringHelper.write(__os, materials);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function jewelRemove_async( __cb : AMI_IEquip_jewelRemove, equipUid : String , materials : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "jewelRemove" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(equipUid);
        SeqStringHelper.write(__os, materials);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function jewelUpdate_async( __cb : AMI_IEquip_jewelUpdate, jewelUid : String , type : EOperType , autoBuy : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "jewelUpdate" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(jewelUid);
        type.__write(__os);
        __os.writeBool(autoBuy);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function strengthen_async( __cb : AMI_IEquip_strengthen, equipUid : String , operatortype : EOperType , autoBuy : Boolean , priorityFlag : EPriorityType ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "strengthen" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(equipUid);
        operatortype.__write(__os);
        __os.writeBool(autoBuy);
        priorityFlag.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

