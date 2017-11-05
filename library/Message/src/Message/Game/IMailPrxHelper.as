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



public class IMailPrxHelper extends RMIProxyObject implements IMailPrx
{
    
    public static const NAME:String = "Message.Game.IMail";

    
    public function IMailPrxHelper()
    {
        name = "IMail";
    }

    public function getMailAttachment_async( __cb : AMI_IMail_getMailAttachment, mailId : Number , attachementIndex : int , isDelete : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getMailAttachment" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeLong(mailId);
        __os.writeInt(attachementIndex);
        __os.writeBool(isDelete);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getMailAttachments_async( __cb : AMI_IMail_getMailAttachments, mailIds : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getMailAttachments" );
        var __os : SerializeStream = new SerializeStream();
        SeqLongHelper.write(__os, mailIds);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function queryMail_async( __cb : AMI_IMail_queryMail, condition : int , type : int , status : int , startIndex : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "queryMail" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(condition);
        __os.writeInt(type);
        __os.writeInt(status);
        __os.writeInt(startIndex);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function readMail_async( __cb : AMI_IMail_readMail, mailId : Number ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "readMail" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeLong(mailId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function removeMail_async( __cb : AMI_IMail_removeMail, mailIds : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "removeMail" );
        var __os : SerializeStream = new SerializeStream();
        SeqLongHelper.write(__os, mailIds);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function sendGmReport_async( __cb : AMI_IMail_sendGmReport, type : int , title : String , content : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "sendGmReport" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(type);
        __os.writeString(title);
        __os.writeString(content);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function sendMail_async( __cb : AMI_IMail_sendMail, toPlayerName : String , title : String , content : String , attachmentCoin : int , attachmentGold : int , uids : Dictionary ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "sendMail" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(toPlayerName);
        __os.writeString(title);
        __os.writeString(content);
        __os.writeInt(attachmentCoin);
        __os.writeInt(attachmentGold);
        DictStrIntHelper.write(__os, uids);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

