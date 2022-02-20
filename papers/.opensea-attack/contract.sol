def storage:
  unknownfb47ccb2Address is addr at storage 0
  unknown4f8a4694Address is addr at storage 1
  stor2 is array of struct at storage 2
  unknown75238c27 is uint8 at storage 3 offset 8
  stor3 is uint256 at storage 3 offset 8
  unknowna1dcd11c is uint8 at storage 3
  stor3 is uint256 at storage 3

def unknown4f8a4694() payable: 
  return unknown4f8a4694Address

def unknown75238c27() payable: 
  return bool(unknown75238c27)

def unknowna1dcd11c() payable: 
  if unknowna1dcd11c >= 2:
      revert with 'NH{q', 33
  return unknowna1dcd11c

def unknownfb47ccb2() payable: 
  return unknownfb47ccb2Address

#
#  Regular functions
#

def _fallback() payable: # default function
  revert

def unknown563277ad(uint256 _param1) payable: 
  require calldata.size - 4 >=′ 32
  require _param1 == addr(_param1)
  require caller == unknownfb47ccb2Address
  unknownfb47ccb2Address = addr(_param1)

def unknowna4a23890() payable: 
  if bool(stor2.length):
      if bool(stor2.length) == stor2.length.field_1 < 32:
          revert with 'NH{q', 34
      if bool(stor2.length):
          if bool(stor2.length) == stor2.length.field_1 < 32:
              revert with 'NH{q', 34
          if stor2.length.field_1:
              if 31 < stor2.length.field_1:
                  mem[128] = uint256(stor2.field_0)
                  idx = 128
                  s = 0
                  while stor2.length.field_1 + 96 > idx:
                      mem[idx + 32] = stor2[s].field_256
                      idx = idx + 32
                      s = s + 1
                      continue 
                  return Array(len=2 * Mask(256, -1, stor2.length.field_1), data=mem[128 len ceil32(stor2.length.field_1)])
              mem[128] = 256 * stor2.length.field_8
      else:
          if bool(stor2.length) == stor2.length.field_1 < 32:
              revert with 'NH{q', 34
          if stor2.length.field_1:
              if 31 < stor2.length.field_1:
                  mem[128] = uint256(stor2.field_0)
                  idx = 128
                  s = 0
                  while stor2.length.field_1 + 96 > idx:
                      mem[idx + 32] = stor2[s].field_256
                      idx = idx + 32
                      s = s + 1
                      continue 
                  return Array(len=2 * Mask(256, -1, stor2.length.field_1), data=mem[128 len ceil32(stor2.length.field_1)])
              mem[128] = 256 * stor2.length.field_8
      mem[ceil32(stor2.length.field_1) + 192 len ceil32(stor2.length.field_1)] = mem[128 len ceil32(stor2.length.field_1)]
      if ceil32(stor2.length.field_1) > stor2.length.field_1:
          mem[ceil32(stor2.length.field_1) + stor2.length.field_1 + 192] = 0
      return Array(len=2 * Mask(256, -1, stor2.length.field_1), data=mem[128 len ceil32(stor2.length.field_1)], mem[(2 * ceil32(stor2.length.field_1)) + 192 len 2 * ceil32(stor2.length.field_1)]), 
  if bool(stor2.length) == stor2.length.field_1 < 32:
      revert with 'NH{q', 34
  if bool(stor2.length):
      if bool(stor2.length) == stor2.length.field_1 < 32:
          revert with 'NH{q', 34
      if stor2.length.field_1:
          if 31 < stor2.length.field_1:
              mem[128] = uint256(stor2.field_0)
              idx = 128
              s = 0
              while stor2.length.field_1 + 96 > idx:
                  mem[idx + 32] = stor2[s].field_256
                  idx = idx + 32
                  s = s + 1
                  continue 
              return Array(len=stor2.length % 128, data=mem[128 len ceil32(stor2.length.field_1)])
          mem[128] = 256 * stor2.length.field_8
  else:
      if bool(stor2.length) == stor2.length.field_1 < 32:
          revert with 'NH{q', 34
      if stor2.length.field_1:
          if 31 < stor2.length.field_1:
              mem[128] = uint256(stor2.field_0)
              idx = 128
              s = 0
              while stor2.length.field_1 + 96 > idx:
                  mem[idx + 32] = stor2[s].field_256
                  idx = idx + 32
                  s = s + 1
                  continue 
              return Array(len=stor2.length % 128, data=mem[128 len ceil32(stor2.length.field_1)])
          mem[128] = 256 * stor2.length.field_8
  mem[ceil32(stor2.length.field_1) + 192 len ceil32(stor2.length.field_1)] = mem[128 len ceil32(stor2.length.field_1)]
  if ceil32(stor2.length.field_1) > stor2.length.field_1:
      mem[ceil32(stor2.length.field_1) + stor2.length.field_1 + 192] = 0
  return Array(len=stor2.length % 128, data=mem[128 len ceil32(stor2.length.field_1)], mem[(2 * ceil32(stor2.length.field_1)) + 192 len 2 * ceil32(stor2.length.field_1)]), 

def unknown7a7b6449(uint256 _param1) payable: 
  require calldata.size - 4 >=′ 32
  require _param1 == addr(_param1)
  mem[96] = 25
  mem[128] = 'saltprefix_transferAssets'
  mem[196] = 32
  mem[228] = 25
  mem[260] = 'saltprefix_transferAssets'
  mem[285] = 0
  mem[160] = 100
  mem[196 len 28] = 0
  mem[192 len 4] = log(string description)
  static call 'console.log'.log(string description) with:
          gas gas_remaining wei
         args 0, 0, 25, 'saltprefix_transferAssets', 0
  require ext_code.size(addr(_param1))
  static call addr(_param1).0x75238c27 with:
          gas gas_remaining wei
  mem[292] = ext_call.return_data[0]
  if not ext_call.success:
      revert with ext_call.return_data[0 len return_data.size]
  else:
      require return_data.size >=′ 32
      require ext_call.return_data == bool(ext_call.return_data[0])
      require ext_call.return_data[0]
      require ext_code.size(addr(_param1))
      static call addr(_param1).0x4f8a4694 with:
              gas gas_remaining wei
      mem[ceil32(return_data.size) + 292] = ext_call.return_data[0]
      if not ext_call.success:
          revert with ext_call.return_data[0 len return_data.size]
      else:
          require return_data.size >=′ 32
          require ext_call.return_data == ext_call.return_data[12 len 20]
          mem[(2 * ceil32(return_data.size)) + 292] = 0xa4a2389000000000000000000000000000000000000000000000000000000000
          require ext_code.size(addr(_param1))
          static call addr(_param1).0xa4a23890 with:
                  gas gas_remaining wei
          if not ext_call.success:
              revert with ext_call.return_data[0 len return_data.size]
          else:
              mem[(2 * ceil32(return_data.size)) + 292 len return_data.size] = ext_call.return_data[0 len return_data.size]
              mem[64] = (4 * ceil32(return_data.size)) + 292
              require return_data.size >=′ 32
              _279 = mem[(2 * ceil32(return_data.size)) + 292]
              require mem[(2 * ceil32(return_data.size)) + 292] <= 18446744073709551615
              require (2 * ceil32(return_data.size)) + mem[(2 * ceil32(return_data.size)) + 292] + 323 <′ (2 * ceil32(return_data.size)) + return_data.size + 292
              _281 = mem[(2 * ceil32(return_data.size)) + mem[(2 * ceil32(return_data.size)) + 292] + 292]
              if mem[(2 * ceil32(return_data.size)) + mem[(2 * ceil32(return_data.size)) + 292] + 292] > 18446744073709551615:
                  revert with 'NH{q', 65
              else:
                  if (4 * ceil32(return_data.size)) + ceil32(ceil32(mem[(2 * ceil32(return_data.size)) + mem[(2 * ceil32(return_data.size)) + 292] + 292])) + 293 > 18446744073709551615 or ceil32(ceil32(mem[(2 * ceil32(return_data.size)) + mem[(2 * ceil32(return_data.size)) + 292] + 292])) + 1 < 0:
                      revert with 'NH{q', 65
                  else:
                      mem[64] = (4 * ceil32(return_data.size)) + ceil32(ceil32(mem[(2 * ceil32(return_data.size)) + mem[(2 * ceil32(return_data.size)) + 292] + 292])) + 293
                      mem[(4 * ceil32(return_data.size)) + 292] = mem[(2 * ceil32(return_data.size)) + mem[(2 * ceil32(return_data.size)) + 292] + 292]
                      require _279 + _281 + 32 <= return_data.size
                      mem[(4 * ceil32(return_data.size)) + 324 len ceil32(_281)] = mem[(2 * ceil32(return_data.size)) + _279 + 324 len ceil32(_281)]
                      if ceil32(_281) <= _281:
                          require ext_code.size(addr(_param1))
                          static call addr(_param1).0xa1dcd11c with:
                                  gas gas_remaining wei
                          mem[mem[64]] = ext_call.return_data[0]
                          if not ext_call.success:
                              revert with ext_call.return_data[0 len return_data.size]
                          else:
                              _505 = mem[64]
                              mem[64] = mem[64] + ceil32(return_data.size)
                              require return_data.size >=′ 32
                              require mem[_505] < 2
                              if mem[_505] > 1:
                                  revert with 'NH{q', 33
                              else:
                                  if mem[_505]:
                                      if mem[_505] > 1:
                                          revert with 'NH{q', 33
                                      else:
                                          if mem[_505] != 1:
                                              stop
                                          else:
                                              _521 = mem[64]
                                              mem[64] = mem[64] + 64
                                              mem[_521] = 22
                                              mem[_521 + 32] = 'HowToCall.DelegateCall'
                                              _525 = mem[64]
                                              mem[mem[64] + 36] = 32
                                              mem[mem[64] + 68] = 22
                                              mem[mem[64] + 100] = 'HowToCall.DelegateCall'
                                              mem[mem[64] + 122] = 0
                                              _741 = mem[64]
                                              mem[mem[64]] = 100
                                              mem[64] = mem[64] + 132
                                              mem[_741 + 32 len 4] = log(string description)
                                              static call 'console.log'.log(string description) with:
                                                      gas gas_remaining wei
                                                     args mem[_741 + 36 len mem[_741] - 4]
                                              _788 = mem[(4 * ceil32(return_data.size)) + 292]
                                              mem[_525 + 132 len ceil32(mem[(4 * ceil32(return_data.size)) + 292])] = mem[(4 * ceil32(return_data.size)) + 324 len ceil32(mem[(4 * ceil32(return_data.size)) + 292])]
                                              if ceil32(_788) <= _788:
                                                  delegate addr(ext_call.return_data).0x0 with:
                                                       gas gas_remaining wei
                                                      args mem[mem[64] + 4 len _525 + _788 + -mem[64] + 128]
                                                  if not return_data.size:
                                                      stop
                                                  else:
                                                      stop
                                              else:
                                                  mem[_525 + _788 + 132] = 0
                                                  delegate addr(ext_call.return_data).0x0 with:
                                                       gas gas_remaining wei
                                                      args mem[mem[64] + 4 len _525 + _788 + -mem[64] + 128]
                                                  if not return_data.size:
                                                      stop
                                                  else:
                                                      stop
                                  else:
                                      _513 = mem[64]
                                      mem[64] = mem[64] + 64
                                      mem[_513] = 14
                                      mem[_513 + 32] = 'HowToCall.Call'
                                      _516 = mem[64]
                                      mem[mem[64] + 36] = 32
                                      mem[mem[64] + 68] = 14
                                      mem[mem[64] + 100] = 'HowToCall.Call'
                                      mem[mem[64] + 114] = 0
                                      _744 = mem[64]
                                      mem[mem[64]] = 100
                                      mem[64] = mem[64] + 132
                                      mem[_744 + 32 len 4] = log(string description)
                                      static call 'console.log'.log(string description) with:
                                              gas gas_remaining wei
                                             args mem[_744 + 36 len mem[_744] - 4]
                                      _789 = mem[(4 * ceil32(return_data.size)) + 292]
                                      mem[_516 + 132 len ceil32(mem[(4 * ceil32(return_data.size)) + 292])] = mem[(4 * ceil32(return_data.size)) + 324 len ceil32(mem[(4 * ceil32(return_data.size)) + 292])]
                                      if ceil32(_789) <= _789:
                                          call addr(ext_call.return_data) with:
                                               gas gas_remaining wei
                                              args mem[mem[64] + 4 len _516 + _789 + -mem[64] + 128]
                                          if not return_data.size:
                                              stop
                                          else:
                                              stop
                                      else:
                                          mem[_516 + _789 + 132] = 0
                                          call addr(ext_call.return_data) with:
                                               gas gas_remaining wei
                                              args mem[mem[64] + 4 len _516 + _789 + -mem[64] + 128]
                                          if not return_data.size:
                                              stop
                                          else:
                                              stop
                      else:
                          mem[(4 * ceil32(return_data.size)) + _281 + 324] = 0
                          require ext_code.size(addr(_param1))
                          static call addr(_param1).0xa1dcd11c with:
                                  gas gas_remaining wei
                          mem[mem[64]] = ext_call.return_data[0]
                          if not ext_call.success:
                              revert with ext_call.return_data[0 len return_data.size]
                          else:
                              _507 = mem[64]
                              mem[64] = mem[64] + ceil32(return_data.size)
                              require return_data.size >=′ 32
                              require mem[_507] < 2
                              if mem[_507] > 1:
                                  revert with 'NH{q', 33
                              else:
                                  if mem[_507]:
                                      if mem[_507] > 1:
                                          revert with 'NH{q', 33
                                      else:
                                          if mem[_507] != 1:
                                              stop
                                          else:
                                              _527 = mem[64]
                                              mem[64] = mem[64] + 64
                                              mem[_527] = 22
                                              mem[_527 + 32] = 'HowToCall.DelegateCall'
                                              _530 = mem[64]
                                              mem[mem[64] + 36] = 32
                                              mem[mem[64] + 68] = 22
                                              mem[mem[64] + 100] = 'HowToCall.DelegateCall'
                                              mem[mem[64] + 122] = 0
                                              _747 = mem[64]
                                              mem[mem[64]] = 100
                                              mem[64] = mem[64] + 132
                                              mem[_747 + 32 len 4] = log(string description)
                                              static call 'console.log'.log(string description) with:
                                                      gas gas_remaining wei
                                                     args mem[_747 + 36 len mem[_747] - 4]
                                              _790 = mem[(4 * ceil32(return_data.size)) + 292]
                                              mem[_530 + 132 len ceil32(mem[(4 * ceil32(return_data.size)) + 292])] = mem[(4 * ceil32(return_data.size)) + 324 len ceil32(mem[(4 * ceil32(return_data.size)) + 292])]
                                              if ceil32(_790) <= _790:
                                                  delegate addr(ext_call.return_data).0x0 with:
                                                       gas gas_remaining wei
                                                      args mem[mem[64] + 4 len _530 + _790 + -mem[64] + 128]
                                                  if not return_data.size:
                                                      stop
                                                  else:
                                                      stop
                                              else:
                                                  mem[_530 + _790 + 132] = 0
                                                  delegate addr(ext_call.return_data).0x0 with:
                                                       gas gas_remaining wei
                                                      args mem[mem[64] + 4 len _530 + _790 + -mem[64] + 128]
                                                  if not return_data.size:
                                                      stop
                                                  else:
                                                      stop
                                  else:
                                      _517 = mem[64]
                                      mem[64] = mem[64] + 64
                                      mem[_517] = 14
                                      mem[_517 + 32] = 'HowToCall.Call'
                                      _519 = mem[64]
                                      mem[mem[64] + 36] = 32
                                      mem[mem[64] + 68] = 14
                                      mem[mem[64] + 100] = 'HowToCall.Call'
                                      mem[mem[64] + 114] = 0
                                      _750 = mem[64]
                                      mem[mem[64]] = 100
                                      mem[64] = mem[64] + 132
                                      mem[_750 + 32 len 4] = log(string description)
                                      static call 'console.log'.log(string description) with:
                                              gas gas_remaining wei
                                             args mem[_750 + 36 len mem[_750] - 4]
                                      _791 = mem[(4 * ceil32(return_data.size)) + 292]
                                      mem[_519 + 132 len ceil32(mem[(4 * ceil32(return_data.size)) + 292])] = mem[(4 * ceil32(return_data.size)) + 324 len ceil32(mem[(4 * ceil32(return_data.size)) + 292])]
                                      if ceil32(_791) <= _791:
                                          call addr(ext_call.return_data) with:
                                               gas gas_remaining wei
                                              args mem[mem[64] + 4 len _519 + _791 + -mem[64] + 128]
                                          if not return_data.size:
                                              stop
                                          else:
                                              stop
                                      else:
                                          mem[_519 + _791 + 132] = 0
                                          call addr(ext_call.return_data) with:
                                               gas gas_remaining wei
                                              args mem[mem[64] + 4 len _519 + _791 + -mem[64] + 128]
                                          if not return_data.size:
                                              stop
                                          else:
                                              stop

def unknown8a10f9ce() payable: 
  require calldata.size - 4 >=′ 192
  require cd == addr(cd)
  require cd < 2
  require cd <= 18446744073709551615
  require cd <′ calldata.size
  require ('cd', 68).length <= 18446744073709551615
  require cd('cd', 68).length + 36 <= calldata.size
  require cd == addr(cd)
  require cd < 2
  require cd <= 18446744073709551615
  require cd <′ calldata.size
  require ('cd', 164).length <= 18446744073709551615
  require cd('cd', 164).length + 36 <= calldata.size
  require caller == unknownfb47ccb2Address
  static call 'console.log'.log(string description) with:
          gas gas_remaining wei
         args 0, 'saltprefix_executeOpenseaDeal', 0
  Mask(248, 0, stor3.field_8) = 1
  unknown4f8a4694Address = addr(cd)
  if bool(stor2.length):
      if bool(stor2.length) == stor2.length.field_1 < 32:
          revert with 'NH{q', 34
      else:
          if ('cd', 68).length:
              stor2.length = (2 * ('cd', 68).length) + 1
              s = 0
              idx = cd[68] + 36
              while cd('cd', 68).length + 36 > idx:
                  stor2[s].field_0 = cd[idx]
                  s = s + 1
                  idx = idx + 32
                  continue 
              idx = Mask(251, 0, ('cd', 68).length + 31) >> 5
              while stor2.length.field_1 + 31 / 32 > idx:
                  stor2[idx].field_0 = 0
                  idx = idx + 1
                  continue 
              if cd > 1:
                  revert with 'NH{q', 33
              else:
                  uint256(stor3.field_0) = cd or Mask(248, 8, uint256(stor3.field_0))
                  if cd > 1:
                      revert with 'NH{q', 33
                  else:
                      if cd[132]:
                          if cd > 1:
                              revert with 'NH{q', 33
                          else:
                              if cd[132] != 1:
                                  Mask(248, 0, stor3.field_8) = 0
                                  unknown4f8a4694Address = 0
                                  if bool(stor2.length):
                                      if bool(stor2.length) == stor2.length.field_1 < 32:
                                          revert with 'NH{q', 34
                                      else:
                                          bool(stor2.length) = 0
                                          stor2.length.field_1 = 2
                                          stor2.length.field_8 = '0x' / 256
                                          idx = 0
                                          while stor2.length.field_1 + 31 / 32 > idx:
                                              stor2[idx].field_0 = 0
                                              idx = idx + 1
                                              continue 
                                          unknowna1dcd11c = 0
                                          stop
                                  else:
                                      if bool(stor2.length) == stor2.length.field_1 < 32:
                                          revert with 'NH{q', 34
                                      else:
                                          bool(stor2.length) = 0
                                          stor2.length.field_1 = 2
                                          stor2.length.field_8 = '0x' / 256
                                          idx = 0
                                          while stor2.length.field_1 + 31 / 32 > idx:
                                              stor2[idx].field_0 = 0
                                              idx = idx + 1
                                              continue 
                                          unknowna1dcd11c = 0
                                          stop
                              else:
                                  delegate addr(cd) with:
                                       gas gas_remaining wei
                                      args call.data[cd('cd', 164).length]
                                  if not return_data.size:
                                      Mask(248, 0, stor3.field_8) = 0
                                      unknown4f8a4694Address = 0
                                      if bool(stor2.length):
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                      else:
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                  else:
                                      Mask(248, 0, stor3.field_8) = 0
                                      unknown4f8a4694Address = 0
                                      if bool(stor2.length):
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                      else:
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                      else:
                          call addr(cd) with:
                               gas gas_remaining wei
                              args call.data[cd('cd', 164).length]
                          if not return_data.size:
                              Mask(248, 0, stor3.field_8) = 0
                              unknown4f8a4694Address = 0
                              if bool(stor2.length):
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                              else:
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                          else:
                              Mask(248, 0, stor3.field_8) = 0
                              unknown4f8a4694Address = 0
                              if bool(stor2.length):
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                              else:
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
          else:
              stor2.length = 0
              idx = 0
              while stor2.length.field_1 + 31 / 32 > idx:
                  stor2[idx].field_0 = 0
                  idx = idx + 1
                  continue 
              if cd > 1:
                  revert with 'NH{q', 33
              else:
                  uint256(stor3.field_0) = cd or Mask(248, 8, uint256(stor3.field_0))
                  if cd > 1:
                      revert with 'NH{q', 33
                  else:
                      if cd[132]:
                          if cd > 1:
                              revert with 'NH{q', 33
                          else:
                              if cd[132] != 1:
                                  Mask(248, 0, stor3.field_8) = 0
                                  unknown4f8a4694Address = 0
                                  if bool(stor2.length):
                                      if bool(stor2.length) == stor2.length.field_1 < 32:
                                          revert with 'NH{q', 34
                                      else:
                                          bool(stor2.length) = 0
                                          stor2.length.field_1 = 2
                                          stor2.length.field_8 = '0x' / 256
                                          idx = 0
                                          while stor2.length.field_1 + 31 / 32 > idx:
                                              stor2[idx].field_0 = 0
                                              idx = idx + 1
                                              continue 
                                          unknowna1dcd11c = 0
                                          stop
                                  else:
                                      if bool(stor2.length) == stor2.length.field_1 < 32:
                                          revert with 'NH{q', 34
                                      else:
                                          bool(stor2.length) = 0
                                          stor2.length.field_1 = 2
                                          stor2.length.field_8 = '0x' / 256
                                          idx = 0
                                          while stor2.length.field_1 + 31 / 32 > idx:
                                              stor2[idx].field_0 = 0
                                              idx = idx + 1
                                              continue 
                                          unknowna1dcd11c = 0
                                          stop
                              else:
                                  delegate addr(cd) with:
                                       gas gas_remaining wei
                                      args call.data[cd('cd', 164).length]
                                  if not return_data.size:
                                      Mask(248, 0, stor3.field_8) = 0
                                      unknown4f8a4694Address = 0
                                      if bool(stor2.length):
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                      else:
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                  else:
                                      Mask(248, 0, stor3.field_8) = 0
                                      unknown4f8a4694Address = 0
                                      if bool(stor2.length):
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                      else:
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                      else:
                          call addr(cd) with:
                               gas gas_remaining wei
                              args call.data[cd('cd', 164).length]
                          if not return_data.size:
                              Mask(248, 0, stor3.field_8) = 0
                              unknown4f8a4694Address = 0
                              if bool(stor2.length):
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                              else:
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                          else:
                              Mask(248, 0, stor3.field_8) = 0
                              unknown4f8a4694Address = 0
                              if bool(stor2.length):
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                              else:
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
  else:
      if bool(stor2.length) == stor2.length.field_1 < 32:
          revert with 'NH{q', 34
      else:
          if ('cd', 68).length:
              stor2.length = (2 * ('cd', 68).length) + 1
              s = 0
              idx = cd[68] + 36
              while cd('cd', 68).length + 36 > idx:
                  stor2[s].field_0 = cd[idx]
                  s = s + 1
                  idx = idx + 32
                  continue 
              idx = Mask(251, 0, ('cd', 68).length + 31) >> 5
              while stor2.length.field_1 + 31 / 32 > idx:
                  stor2[idx].field_0 = 0
                  idx = idx + 1
                  continue 
              if cd > 1:
                  revert with 'NH{q', 33
              else:
                  uint256(stor3.field_0) = cd or Mask(248, 8, uint256(stor3.field_0))
                  if cd > 1:
                      revert with 'NH{q', 33
                  else:
                      if cd[132]:
                          if cd > 1:
                              revert with 'NH{q', 33
                          else:
                              if cd[132] != 1:
                                  Mask(248, 0, stor3.field_8) = 0
                                  unknown4f8a4694Address = 0
                                  if bool(stor2.length):
                                      if bool(stor2.length) == stor2.length.field_1 < 32:
                                          revert with 'NH{q', 34
                                      else:
                                          bool(stor2.length) = 0
                                          stor2.length.field_1 = 2
                                          stor2.length.field_8 = '0x' / 256
                                          idx = 0
                                          while stor2.length.field_1 + 31 / 32 > idx:
                                              stor2[idx].field_0 = 0
                                              idx = idx + 1
                                              continue 
                                          unknowna1dcd11c = 0
                                          stop
                                  else:
                                      if bool(stor2.length) == stor2.length.field_1 < 32:
                                          revert with 'NH{q', 34
                                      else:
                                          bool(stor2.length) = 0
                                          stor2.length.field_1 = 2
                                          stor2.length.field_8 = '0x' / 256
                                          idx = 0
                                          while stor2.length.field_1 + 31 / 32 > idx:
                                              stor2[idx].field_0 = 0
                                              idx = idx + 1
                                              continue 
                                          unknowna1dcd11c = 0
                                          stop
                              else:
                                  delegate addr(cd) with:
                                       gas gas_remaining wei
                                      args call.data[cd('cd', 164).length]
                                  if not return_data.size:
                                      Mask(248, 0, stor3.field_8) = 0
                                      unknown4f8a4694Address = 0
                                      if bool(stor2.length):
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                      else:
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                  else:
                                      Mask(248, 0, stor3.field_8) = 0
                                      unknown4f8a4694Address = 0
                                      if bool(stor2.length):
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                      else:
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                      else:
                          call addr(cd) with:
                               gas gas_remaining wei
                              args call.data[cd('cd', 164).length]
                          if not return_data.size:
                              Mask(248, 0, stor3.field_8) = 0
                              unknown4f8a4694Address = 0
                              if bool(stor2.length):
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                              else:
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                          else:
                              Mask(248, 0, stor3.field_8) = 0
                              unknown4f8a4694Address = 0
                              if bool(stor2.length):
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                              else:
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
          else:
              stor2.length = 0
              idx = 0
              while stor2.length.field_1 + 31 / 32 > idx:
                  stor2[idx].field_0 = 0
                  idx = idx + 1
                  continue 
              if cd > 1:
                  revert with 'NH{q', 33
              else:
                  uint256(stor3.field_0) = cd or Mask(248, 8, uint256(stor3.field_0))
                  if cd > 1:
                      revert with 'NH{q', 33
                  else:
                      if cd[132]:
                          if cd > 1:
                              revert with 'NH{q', 33
                          else:
                              if cd[132] != 1:
                                  Mask(248, 0, stor3.field_8) = 0
                                  unknown4f8a4694Address = 0
                                  if bool(stor2.length):
                                      if bool(stor2.length) == stor2.length.field_1 < 32:
                                          revert with 'NH{q', 34
                                      else:
                                          bool(stor2.length) = 0
                                          stor2.length.field_1 = 2
                                          stor2.length.field_8 = '0x' / 256
                                          idx = 0
                                          while stor2.length.field_1 + 31 / 32 > idx:
                                              stor2[idx].field_0 = 0
                                              idx = idx + 1
                                              continue 
                                          unknowna1dcd11c = 0
                                          stop
                                  else:
                                      if bool(stor2.length) == stor2.length.field_1 < 32:
                                          revert with 'NH{q', 34
                                      else:
                                          bool(stor2.length) = 0
                                          stor2.length.field_1 = 2
                                          stor2.length.field_8 = '0x' / 256
                                          idx = 0
                                          while stor2.length.field_1 + 31 / 32 > idx:
                                              stor2[idx].field_0 = 0
                                              idx = idx + 1
                                              continue 
                                          unknowna1dcd11c = 0
                                          stop
                              else:
                                  delegate addr(cd) with:
                                       gas gas_remaining wei
                                      args call.data[cd('cd', 164).length]
                                  if not return_data.size:
                                      Mask(248, 0, stor3.field_8) = 0
                                      unknown4f8a4694Address = 0
                                      if bool(stor2.length):
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                      else:
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                  else:
                                      Mask(248, 0, stor3.field_8) = 0
                                      unknown4f8a4694Address = 0
                                      if bool(stor2.length):
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                                      else:
                                          if bool(stor2.length) == stor2.length.field_1 < 32:
                                              revert with 'NH{q', 34
                                          else:
                                              bool(stor2.length) = 0
                                              stor2.length.field_1 = 2
                                              stor2.length.field_8 = '0x' / 256
                                              idx = 0
                                              while stor2.length.field_1 + 31 / 32 > idx:
                                                  stor2[idx].field_0 = 0
                                                  idx = idx + 1
                                                  continue 
                                              unknowna1dcd11c = 0
                                              stop
                      else:
                          call addr(cd) with:
                               gas gas_remaining wei
                              args call.data[cd('cd', 164).length]
                          if not return_data.size:
                              Mask(248, 0, stor3.field_8) = 0
                              unknown4f8a4694Address = 0
                              if bool(stor2.length):
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                              else:
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                          else:
                              Mask(248, 0, stor3.field_8) = 0
                              unknown4f8a4694Address = 0
                              if bool(stor2.length):
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop
                              else:
                                  if bool(stor2.length) == stor2.length.field_1 < 32:
                                      revert with 'NH{q', 34
                                  else:
                                      bool(stor2.length) = 0
                                      stor2.length.field_1 = 2
                                      stor2.length.field_8 = '0x' / 256
                                      idx = 0
                                      while stor2.length.field_1 + 31 / 32 > idx:
                                          stor2[idx].field_0 = 0
                                          idx = idx + 1
                                          continue 
                                      unknowna1dcd11c = 0
                                      stop

