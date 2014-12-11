package com.dcx.game.component.loading
{

import com.dcx.game.events.AssetTotalBytesEvent;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

//--------------------------------------
//  Events
//--------------------------------------
/**
 * Dispatched when the download operation commences
 * following a call to the BackupURLLoaderItem.start() method.
 * @eventType flash.events.Event.OPEN
 */
[Event(name="open", type="flash.events.Event")]

/**
 * Dispatched after all the received data is decoded and placed
 * in the data property of the BackupURLLoaderItem object.
 * @eventType flash.events.Event.COMPLETE
 */
[Event(name="complete", type="flash.events.Event")]

/**
 * Dispatched when data is received as the download operation progresses.
 * @eventType flash.events.ProgressEvent.PROGRESS
 */
[Event(name="progress", type="flash.events.ProgressEvent")]

/**
 * Dispatched when bytesTotal data is changed
 * during the download operation progresses.
 * @eventType AssetTotalBytesEvent.CHANGE
 */
[Event(name="change", type="com.dcx.game.events.AssetTotalBytesEvent")]

/**
 * Dispatched if a call to BackupURLLoaderItem.start() results in a fatal
 * error that terminates the download.
 * @eventType flash.events.IOErrorEvent.IO_ERROR
 */
[Event(name="ioError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to BackupURLLoaderItem.start() results in a fatal
 * network error that terminates the download.
 * @eventType flash.events.IOErrorEvent.NETWORK_ERROR
 */
[Event(name="networkError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to BackupURLLoaderItem.start() results in a fatal
 * disk error that terminates the download.
 * @eventType flash.events.IOErrorEvent.DISK_ERROR
 */
[Event(name="diskError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to BackupURLLoaderItem.start() results in a fatal
 * verify error that terminates the download.
 * @eventType flash.events.IOErrorEvent.VERIFY_ERROR
 */
[Event(name="verifyError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to BackupURLLoaderItem.start() attempts to load
 * data from a server outside the security sandbox.
 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
 */
[Event(name="securityError", type="flash.events.SecurityErrorEvent")]

/**
 * Leaf node of asset loading composite system, downloads data from a URL with
 * a backup URL as text, binary data, or URL-encoded variables.
 *
 * <p>It provides a backup plan
 * if the first request is unavailable or a wrong response.</p>
 *
 */
public class BackupURLLoaderItem extends URLLoaderItem
{

    //--------------------------------------------------------------------------
    //
    //  Class Variables
    //
    //--------------------------------------------------------------------------
    /**
     * Define the node name of response error
     */
    private static const ERROR_RESPONSE:String = "error";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     * BackupURLLoaderItem is a wrapper class for
     * <code>flash.net.URLLoader</code> which has a backup enabled, and is a
     * leaf node in the composite asset loading system.
     * @param url URL to load.
     * @param backupUrl backup URL to load.
     * @param bytesTotal Total size of asset in bytes (optional).
     */
    public function BackupURLLoaderItem(url:String, backupUrl:String,
                                                            bytesTotal:uint = 0)
    {
        super(url, bytesTotal);
        this.originalUrl = url;
        this.backupUrl = backupUrl;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    private var backupUrl:String;
    private var originalUrl:String;
    private var isBackup:Boolean;

    //--------------------------------------------------------------------------
    //
    //  Public methods
    //
    //--------------------------------------------------------------------------

    /**
     * Begins the load.
     */
    override public function start():void
    {
        _url = originalUrl;
        isBackup = false;
        super.start();
    }

    //--------------------------------------------------------------------------
    //
    //  Virtual methods
    //
    //--------------------------------------------------------------------------
    /**
     * @private
     * Begins the load backup URL
     */
    private function loadBackup():void
    {
        _url = backupUrl;
        isBackup = true;
        super.start();
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    override protected function loader_completeHandler(event:Event):void
    {
        if (isBackup)
        {
            super.loader_completeHandler(event);
            return;
        }
        try
        {
            //Type checking
            var feedXML:XML = XML(this.content);
            //Response checking if the first node is "error"
            if (feedXML.name().toString().toLowerCase() == ERROR_RESPONSE)
            {
                loadBackup();
            }
            else
            {
                super.loader_completeHandler(event);
            }
        }
        catch(e:TypeError)
        {
            //Malformed feed, load Backup
            loadBackup();
        }
    }

    override protected function loader_errorHandler(event:Event):void
    {
        if(isBackup)
        {
            super.loader_errorHandler(event);
        }
        else
        {
            loadBackup();
        }
    }
}

}