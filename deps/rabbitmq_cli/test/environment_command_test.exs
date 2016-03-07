## The contents of this file are subject to the Mozilla Public License
## Version 1.1 (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License
## at http://www.mozilla.org/MPL/
##
## Software distributed under the License is distributed on an "AS IS"
## basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
## the License for the specific language governing rights and
## limitations under the License.
##
## The Original Code is RabbitMQ.
##
## The Initial Developer of the Original Code is GoPivotal, Inc.
## Copyright (c) 2007-2016 Pivotal Software, Inc.  All rights reserved.


defmodule EnvironmentCommandTest do
  use ExUnit.Case, async: false
  import TestHelper

  setup_all do
    :net_kernel.start([:rabbitmqctl, :shortnames])
    on_exit([], fn -> :net_kernel.stop() end)
    :ok
  end

  setup context do
    :net_kernel.connect_node(context[:target])
    on_exit(context, fn -> :erlang.disconnect_node(context[:target]) end)
    :ok
  end

  @tag target: get_rabbit_hostname()
  test "environment request on default RabbitMQ node" do
    assert EnvironmentCommand.environment([], [])[:kernel] != nil
    assert EnvironmentCommand.environment([], [])[:rabbit] != nil
  end

  @tag target: get_rabbit_hostname()
  test "environment request on active RabbitMQ node", context do
    assert EnvironmentCommand.environment([], [node: context[:target]])[:kernel] != nil
    assert EnvironmentCommand.environment([], [node: context[:target]])[:rabbit] != nil
  end

  @tag target: :jake@thedog
  test "environment request on nonexistent RabbitMQ node", context do
    assert EnvironmentCommand.environment([], [node: context[:target]]) == {:badrpc, :nodedown}
  end
end
