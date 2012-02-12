%% @copyright 2012 Opscode, Inc. All Rights Reserved
%% @author Tim Dysinger <timd@opscode.com>
%%
%% Licensed to the Apache Software Foundation (ASF) under one or more
%% contributor license agreements.  See the NOTICE file distributed
%% with this work for additional information regarding copyright
%% ownership.  The ASF licenses this file to you under the Apache
%% License, Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain a copy of
%% the License at http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
%% implied.  See the License for the specific language governing
%% permissions and limitations under the License.

-module(bookshelf_xml_tests).
-include("bookshelf.hrl").

list_buckets_test_() ->
    [{"should render ListAllMyBucketsResult",
      fun() ->
              Buckets = [{"lol", "011-02-10T21:42:17.000Z"},
                         {"cat", "011-02-10T21:42:17.000Z"}],
              {'ListAllMyBucketsResult',undefined,
               {'CanonicalUser',undefined,"abc123","bobo-t-clown"},
               {'ListAllMyBucketsList',undefined,
                [{'ListAllMyBucketsEntry',undefined,"lol",
                  "011-02-10T21:42:17.000Z"},
                 {'ListAllMyBucketsEntry',undefined,"cat",
                  "011-02-10T21:42:17.000Z"}]}} =
                  bookshelf_xml:list_buckets(Buckets)
      end
     }].
