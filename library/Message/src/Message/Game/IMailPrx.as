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



public interface IMailPrx 
{
    function sendGmReport_async( __cb : AMI_IMail_sendGmReport, type : int , title : String , content : String ) : void ;

    function sendMail_async( __cb : AMI_IMail_sendMail, toPlayerName : String , title : String , content : String , attachmentCoin : int , attachmentGold : int , uids : Dictionary ) : void ;

    function readMail_async( __cb : AMI_IMail_readMail, mailId : Number ) : void ;

    function getMailAttachments_async( __cb : AMI_IMail_getMailAttachments, mailIds : Array ) : void ;

    function getMailAttachment_async( __cb : AMI_IMail_getMailAttachment, mailId : Number , attachementIndex : int , isDelete : Boolean ) : void ;

    function removeMail_async( __cb : AMI_IMail_removeMail, mailIds : Array ) : void ;

    function queryMail_async( __cb : AMI_IMail_queryMail, condition : int , type : int , status : int , startIndex : int ) : void ;
}
}

