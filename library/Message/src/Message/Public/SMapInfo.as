// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Public{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SMapInfo
{
    public var mapId : int;

    public var pieceWidth : int;

    public var pieceHeight : int;

    public var baseWorldLayerColX : int;

    public var baseWorldLayerColY : int;

    public var gridWidth : int;

    public var gridHeight : int;

    public var connectedPointY : int;

    [ArrayElementType("Array")]
    public var mapData : Array;

    public function SMapInfo()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(mapId);
        __os.writeInt(pieceWidth);
        __os.writeInt(pieceHeight);
        __os.writeInt(baseWorldLayerColX);
        __os.writeInt(baseWorldLayerColY);
        __os.writeInt(gridWidth);
        __os.writeInt(gridHeight);
        __os.writeInt(connectedPointY);
        SeqSeqByteHelper.write(__os, mapData);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        mapId = __is.readInt();
        pieceWidth = __is.readInt();
        pieceHeight = __is.readInt();
        baseWorldLayerColX = __is.readInt();
        baseWorldLayerColY = __is.readInt();
        gridWidth = __is.readInt();
        gridHeight = __is.readInt();
        connectedPointY = __is.readInt();
        mapData = SeqSeqByteHelper.read(__is);
    }
}
}
