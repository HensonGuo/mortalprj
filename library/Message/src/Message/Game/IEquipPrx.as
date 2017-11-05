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



public interface IEquipPrx 
{
    function strengthen_async( __cb : AMI_IEquip_strengthen, equipUid : String , operatortype : EOperType , autoBuy : Boolean , priorityFlag : EPriorityType ) : void ;

    function jewelEmbed_async( __cb : AMI_IEquip_jewelEmbed, equipUid : String , materials : Array ) : void ;

    function jewelRemove_async( __cb : AMI_IEquip_jewelRemove, equipUid : String , materials : Array ) : void ;

    function jewelDecompose_async( __cb : AMI_IEquip_jewelDecompose, jewelUids : Array ) : void ;

    function jewelUpdate_async( __cb : AMI_IEquip_jewelUpdate, jewelUid : String , type : EOperType , autoBuy : Boolean ) : void ;

    function equipRefresh_async( __cb : AMI_IEquip_equipRefresh, equipUid : String , type : EOperType , autoBuy : Boolean , priorityFlag : EPriorityType , lockDict : Dictionary , expectAttr : Dictionary , expectAttrAll : int ) : void ;

    function equipRefreshReplace_async( __cb : AMI_IEquip_equipRefreshReplace, equipUid : String , replaceIndex : int ) : void ;

    function equipDecompose_async( __cb : AMI_IEquip_equipDecompose, equipUid : String , priority : EPriorityType ) : void ;

    function equipColorAdvance_async( __cb : AMI_IEquip_equipColorAdvance, equipUid : String , operatortype : EOperType , autoBuy : Boolean , priorityFlag : EPriorityType ) : void ;

    function equipQualityAdvance_async( __cb : AMI_IEquip_equipQualityAdvance, equipUid : String , operatortype : EOperType , autoBuy : Boolean , priorityFlag : EPriorityType ) : void ;
}
}

